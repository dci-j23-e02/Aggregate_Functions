## Exercises :

### Exercise 1: Calculate the Total Number of Venues
- **Question:** How many venues are there in the database?
- **Hint:** Use the `COUNT()` function on the `venues` table.

### Exercise 2: Find the Average Event Duration
- **Question:** What is the average duration of all events, in hours?
- **Hint:** Use the `AVG()` function with `EXTRACT(EPOCH FROM (end_time - start_time))` on the `events` table.

### Exercise 3: Identify the Event with the Highest Number of Tickets Sold
- **Question:** Which event has the highest number of tickets sold?
- **Hint:** Use the `COUNT()` function on the `tickets` table where `status = 'sold'`, and apply `ORDER BY` with `DESC` to find the top result.

### Exercise 4: Determine the Range of Ticket Prices for Each Event
- **Question:** For each event, what is the range of ticket prices (difference between the highest and lowest price)?
- **Hint:** Use the `MAX()` and `MIN()` functions on the `tickets` table and subtract them to find the range.

### Exercise 5: Calculate the Total Revenue from Ticket Sales for Each Event Category
- **Question:** What is the total revenue generated from ticket sales for each event category?
- **Hint:** Use the `SUM()` function on the `tickets` table joined with the `events` table, grouping by the event category.

### Exercise 6: Find Events with Only Excellent Ratings
- **Question:** Which events have received only 'excellent' ratings?
- **Hint:** Use the `MIN()` and `MAX()` functions on the `reviews` table to ensure all ratings for an event are 'excellent'.

### Exercise 7: List the Number of Events Scheduled Per Month
- **Question:** How many events are scheduled for each month of the year?
- **Hint:** Use the `COUNT()` function on the `events` table and group the results by month using `EXTRACT(MONTH FROM scheduled_date)`.

### Exercise 8: Average Ticket Price for Sold and Reserved Tickets
- **Question:** What is the average price of tickets that have been either sold or reserved?
- **Hint:** Use the `AVG()` function on the `tickets` table where the `status` is either 'sold' or 'reserved'.
