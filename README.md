# Aggregate Functions

##  Events Scheduling Database Design
We will give this  assignment as live coding  example 

### Adjusting Tables for Automatic UUID Generation

```sql
-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Recreate tables with automatic UUID generation
DROP TABLE IF EXISTS events, attendees, venues, organizers, event_schedules, tickets, reviews, user_preferences CASCADE;

CREATE TABLE venues (
    venue_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT,
    location JSONB,
    capacity INTEGER,
    contact_info TEXT[]
);

CREATE TABLE organizers (
    organizer_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT,
    contact_info JSONB
);

CREATE TABLE events (
    event_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT,
    description JSONB,
    venue_id UUID REFERENCES venues(venue_id),
    organizer_id UUID REFERENCES organizers(organizer_id),
    schedule TSRANGE
);

CREATE TABLE attendees (
    attendee_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT,
    email TEXT,
    preferences JSONB,
    tickets UUID[]
);

CREATE TABLE event_schedules (
    schedule_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID REFERENCES events(event_id),
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    description TEXT
);

CREATE TYPE ticket_status AS ENUM ('available', 'sold', 'reserved');
CREATE TABLE tickets (
    ticket_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID REFERENCES events(event_id),
    attendee_id UUID REFERENCES attendees(attendee_id),
    price NUMERIC,
    status ticket_status
);

CREATE TYPE rating_enum AS ENUM ('poor', 'fair', 'good', 'excellent');
CREATE TABLE reviews (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID REFERENCES events(event_id),
    attendee_id UUID REFERENCES attendees(attendee_id),
    rating rating_enum,
    comment TEXT
);

CREATE TABLE user_preferences (
    user_id UUID PRIMARY KEY REFERENCES attendees(attendee_id),
    interests TEXT[],
    notifications_enabled BOOLEAN
);
```
### 2. Insert Sample Data

For the `events` table, as an example, you would insert records without specifying the `event_id` since it's automatically generated. Use subqueries to resolve foreign keys.


 ```sql
-- Insert sample data into venues and organizers first
INSERT INTO venues (name, location, capacity, contact_info) VALUES
('Venue A', '{"address": "123 Main St", "city": "Metropolis"}', 1000, ARRAY['contact@venuea.com']),
('Venue B', '{"address": "456 Side St", "city": "Gotham"}', 500, ARRAY['info@venueb.com']);

INSERT INTO organizers (name, contact_info) VALUES
('Organizer One', '{"email": "orgone@email.com", "phone": "123-456-7890"}'),
('Organizer Two', '{"email": "orgtwo@email.com", "phone": "098-765-4321"}');

-- Insert into events using subqueries for venue_id and organizer_id
INSERT INTO events (title, description, venue_id, organizer_id, schedule) VALUES
('Tech Conference', '{"topics":["AI", "Cloud"]}', (SELECT venue_id FROM venues WHERE name = 'Venue A'), (SELECT organizer_id FROM organizers WHERE name = 'Organizer One'), '[2023-10-01 09:00, 2023-10-01 17:00]'),
('Music Festival', '{"genres":["Rock", "Pop"]}', (SELECT venue_id FROM venues WHERE name = 'Venue B'), (SELECT organizer_id FROM organizers WHERE name = 'Organizer Two'), '[2023-08-05 12:00, 2023-08-05 23:00]');
```

Following the pattern established for the `events` table, let's continue inserting sample data into the other tables, using subqueries for foreign keys where necessary. Note that for simplicity and brevity, the examples will insert a minimal amount of data. You should expand upon these with more records as needed for your assignment.

### Attendees Table

```sql
INSERT INTO attendees (name, email, preferences) VALUES
('John Doe', 'john.doe@example.com', '{"interests": ["Music", "Tech"], "food": "Vegan"}'),
('Jane Smith', 'jane.smith@example.com', '{"interests": ["Art", "Literature"], "food": "Gluten Free"}'),
('Alice Johnson', 'alice.johnson@example.com', '{"interests": ["Tech", "Science"], "food": "Anything"}'),
('Bob Brown', 'bob.brown@example.com', '{"interests": ["Music", "Dance"], "food": "Vegetarian"}'),
('Charlie Davis', 'charlie.davis@example.com', '{"interests": ["Sports", "Tech"], "food": "Keto"}');
```

### Event Schedules Table

Assuming you have already inserted data into the `events` table, you can add schedules like this:

```sql
INSERT INTO event_schedules (event_id, start_time, end_time, description) VALUES
((SELECT event_id FROM events WHERE title = 'Tech Conference'), '2023-10-01 09:00:00+00', '2023-10-01 17:00:00+00', 'Day 1 of Tech Conference'),
((SELECT event_id FROM events WHERE title = 'Tech Conference'), '2023-10-02 09:00:00+00', '2023-10-02 17:00:00+00', 'Day 2 of Tech Conference'),
((SELECT event_id FROM events WHERE title = 'Music Festival'), '2023-08-05 12:00:00+00', '2023-08-05 23:00:00+00', 'Music Festival Day'),
((SELECT event_id FROM events WHERE title = 'Tech Conference'), '2023-10-03 09:00:00+00', '2023-10-03 17:00:00+00', 'Day 3 of Tech Conference'),
((SELECT event_id FROM events WHERE title = 'Music Festival'), '2023-08-06 12:00:00+00', '2023-08-06 23:00:00+00', 'Music Festival Second Day');
```

### Tickets Table

For tickets, you'll need to reference both `events` and `attendees`. Here's how you might insert some sample tickets:

```sql
INSERT INTO tickets (event_id, attendee_id, price, status) VALUES
((SELECT event_id FROM events WHERE title = 'Tech Conference'), (SELECT attendee_id FROM attendees WHERE name = 'John Doe'), 299.99, 'sold'),
((SELECT event_id FROM events WHERE title = 'Tech Conference'), (SELECT attendee_id FROM attendees WHERE name = 'Alice Johnson'), 299.99, 'available'),
((SELECT event_id FROM events WHERE title = 'Music Festival'), (SELECT attendee_id FROM attendees WHERE name = 'Bob Brown'), 149.99, 'sold'),
((SELECT event_id FROM events WHERE title = 'Music Festival'), (SELECT attendee_id FROM attendees WHERE name = 'Charlie Davis'), 149.99, 'reserved'),
((SELECT event_id FROM events WHERE title = 'Tech Conference'), (SELECT attendee_id FROM attendees WHERE name = 'Jane Smith'), 299.99, 'sold');
```

### Reviews Table

Inserting reviews would look something like this:

```sql
INSERT INTO reviews (event_id, attendee_id, rating, comment) VALUES
((SELECT event_id FROM events WHERE title = 'Tech Conference'), (SELECT attendee_id FROM attendees WHERE name = 'John Doe'), 'excellent', 'Fantastic event! Very informative.'),
((SELECT event_id FROM events WHERE title = 'Tech Conference'), (SELECT attendee_id FROM attendees WHERE name = 'Alice Johnson'), 'good', 'Well organized but could have more interactive sessions.'),
((SELECT event_id FROM events WHERE title = 'Music Festival'), (SELECT attendee_id FROM attendees WHERE name = 'Bob Brown'), 'excellent', 'Best music festival ever!'),
((SELECT event_id FROM events WHERE title = 'Music Festival'), (SELECT attendee_id FROM attendees WHERE name = 'Charlie Davis'), 'fair', 'It was okay, but too crowded.'),
((SELECT event_id FROM events WHERE title = 'Tech Conference'), (SELECT attendee_id FROM attendees WHERE name = 'Jane Smith'), 'good', 'Interesting topics, but the venue was a bit cramped.');
```

### User Preferences Table

Finally, for user preferences:

```sql
INSERT INTO user_preferences (user_id, interests, notifications_enabled) VALUES
((SELECT attendee_id FROM attendees WHERE name = 'John Doe'), ARRAY['Tech', 'Music'], TRUE),
((SELECT attendee_id FROM attendees WHERE name = 'Jane Smith'), ARRAY['Art', 'Literature'], FALSE),
((SELECT attendee_id FROM attendees WHERE name = 'Alice Johnson'), ARRAY['Science', 'Tech'], TRUE),
((SELECT attendee_id FROM attendees WHERE name = 'Bob Brown'), ARRAY['Music', 'Dance'], TRUE),
((SELECT attendee_id FROM attendees WHERE name = 'Charlie Davis'), ARRAY['Sports', 'Tech'], FALSE);
```

This approach dynamically links records using subqueries based on known attributes, avoiding the need to manually insert or track UUIDs. Remember to adjust and expand upon these examples based on your specific assignment requirements and the data you wish to represent.

### 3. Write Queries

#### 1. Find all events happening in October 2023.
```sql
SELECT * FROM events
WHERE schedule && '[2023-10-01 00:00, 2023-10-31 23:59]'::tsrange;
```

#### 2. List attendees who have 'Music' as an interest.
```sql
SELECT * FROM attendees
WHERE preferences @> '{"interests": ["Music"]}';
```

#### 3. Retrieve all venues with a capacity greater than 500.
```sql
SELECT * FROM venues
WHERE capacity > 500;
```

#### 4. Get the contact information for organizers of 'Tech Conference'.
```sql
SELECT o.contact_info FROM organizers o
JOIN events e ON o.organizer_id = e.organizer_id
WHERE e.title = 'Tech Conference';
```

#### 5. Find all events with tickets still available.
```sql
SELECT e.* FROM events e
JOIN tickets t ON e.event_id = t.event_id
WHERE t.status = 'available'
GROUP BY e.event_id;
```

#### 6. List all reviews for a specific event, ordered by rating.
```sql
SELECT * FROM reviews
WHERE event_id = 'specific-event-uuid'
ORDER BY rating;
```

#### 7. Update the schedule for an event.
```sql
UPDATE events
SET schedule = '[new-start-time, new-end-time]'::tsrange
WHERE event_id = 'specific-event-uuid';
```

#### 8. Find attendees who have enabled notifications.
```sql
SELECT * FROM attendees
WHERE attendee_id IN (SELECT user_id FROM user_preferences WHERE notifications_enabled = TRUE);
```

#### 9. Retrieve the total number of tickets sold for each event.
```sql
SELECT event_id, COUNT(ticket_id) AS tickets_sold
FROM tickets
WHERE status = 'sold'
GROUP BY event_id;
```

#### 10. List all events an attendee is going to, based on their ticket purchases.
```sql
SELECT e.* FROM events e
JOIN tickets t ON e.event_id = t.event_id
WHERE t.attendee_id = 'specific-attendee-uuid';
```
