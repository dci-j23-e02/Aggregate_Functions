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

