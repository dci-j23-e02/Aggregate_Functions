-- Exercise 1: Calculate the Total Number of Venues

-- Question: How many venues are there in the database?

--Expected Query:


SELECT COUNT(*) AS total_venues
FROM venues;


-- Exercise 2: Find the Average Event Duration

-- Assuming there's a `start_time` and `end_time` for each event in the `events` table.

-- Question:  What is the average duration of all events, in hours?

-- Expected Query:


SELECT AVG(EXTRACT(EPOCH FROM (end_time - start_time))/3600) AS average_duration_hours
FROM events;


-- Exercise 3: Identify the Event with the Highest Number of Tickets Sold

-- Question:  Which event has the highest number of tickets sold?

-- Expected Query: 

 
SELECT event_id, COUNT(ticket_id) AS tickets_sold
FROM tickets
WHERE status = 'sold'
GROUP BY event_id
ORDER BY tickets_sold DESC
LIMIT 1;
 

-- Exercise 4: Determine the Range of Ticket Prices for Each Event

-- Question:  For each event, what is the range of ticket prices (difference between the highest and lowest price)?

-- Expected Query:

 
SELECT event_id, (MAX(price) - MIN(price)) AS price_range
FROM tickets
GROUP BY event_id;
 

--  Exercise 5: Calculate the Total Revenue from Ticket Sales for Each Event Category

-- Assuming there's a `category` column in the `events` table.

-- Question:  What is the total revenue generated from ticket sales for each event category?

-- Expected Query: 

 
SELECT e.category, SUM(t.price) AS total_revenue
FROM tickets t
JOIN events e ON t.event_id = e.event_id
GROUP BY e.category;
 

-- Exercise 6: Find Events with Only Excellent Ratings

-- Question:  Which events have received only 'excellent' ratings?

-- Expected Query: 

 
SELECT event_id
FROM reviews
GROUP BY event_id
HAVING MIN(rating) = 'excellent' AND MAX(rating) = 'excellent';
 

-- Exercise 7: List the Number of Events Scheduled Per Month

-- Assuming there's a `scheduled_date` column in the `events` table.

-- Question:  How many events are scheduled for each month of the year?

-- Expected Query: 

 
SELECT EXTRACT(MONTH FROM scheduled_date) AS month, COUNT(event_id) AS events_count
FROM events
GROUP BY month
ORDER BY month;
 

-- Exercise 8: Average Ticket Price for Sold and Reserved Tickets

-- Question:  What is the average price of tickets that have been either sold or reserved?

-- Expected Query: 

 
SELECT AVG(price) AS average_price
FROM tickets
WHERE status IN ('sold', 'reserved');
 
