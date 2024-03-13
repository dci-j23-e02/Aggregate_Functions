

### 1. AVG()

The `AVG()` function calculates the average value of a numeric column.

- **Usage**: `SELECT AVG(column_name) FROM table_name;`
- **Example**: To find the average price of tickets sold, you would use `SELECT AVG(price) FROM tickets;`.
- **Step by Step**: The function sums up all the numeric values in the specified column and then divides by the count of those values to find the average.

### 2. COUNT()

The `COUNT()` function returns the number of rows that match a specified criterion.

- **Usage**: `SELECT COUNT(column_name) FROM table_name;` or `SELECT COUNT(*) FROM table_name;` for all rows.
- **Example**: To count the number of events, you would use `SELECT COUNT(event_id) FROM events;`.
- **Step by Step**: The function iterates through each row in the set, incrementing a counter for each row that meets the criteria (or every row if `*` is used), and returns the final count.

### 3. MAX()

The `MAX()` function returns the maximum value in a specified column.

- **Usage**: `SELECT MAX(column_name) FROM table_name;`
- **Example**: To find the highest ticket price, you would use `SELECT MAX(price) FROM tickets;`.
- **Step by Step**: The function compares all values in the specified column and keeps track of the highest value encountered, returning it as the result.

### 4. MIN()

The `MIN()` function returns the minimum value in a specified column.

- **Usage**: `SELECT MIN(column_name) FROM table_name;`
- **Example**: To find the lowest ticket price, you would use `SELECT MIN(price) FROM tickets;`.
- **Step by Step**: Similar to `MAX()`, but it keeps track of the lowest value encountered in the specified column.

### 5. SUM()

The `SUM()` function calculates the total sum of a numeric column.

- **Usage**: `SELECT SUM(column_name) FROM table_name;`
- **Example**: To calculate the total revenue from ticket sales, you would use `SELECT SUM(price) FROM tickets;`.
- **Step by Step**: The function iterates through each row, adding the value of the specified column to a running total, and returns the sum.

### 6. ROUND()

The `ROUND()` function rounds a numeric field to the number of decimals specified.

- **Usage**: `SELECT ROUND(column_name, decimals) FROM table_name;`
- **Example**: To round the average ticket price to 2 decimal places, you would use `SELECT ROUND(AVG(price), 2) FROM tickets;`.
- **Step by Step**: The function takes each numeric value, rounds it to the specified number of decimal places, and returns the rounded value.

### 7. GROUP BY

The `GROUP BY` clause groups rows that have the same values in specified columns into summary rows.

- **Usage**: `SELECT column_name, AGG_FUNC(column_name) FROM table_name GROUP BY column_name;`
- **Example**: To count the number of tickets sold per event, you would use `SELECT event_id, COUNT(ticket_id) FROM tickets GROUP BY event_id;`.
- **Step by Step**: The query segregates rows into groups based on the values in the specified column(s) and then applies the aggregation function (like `COUNT()`, `SUM()`, etc.) to each group separately.

### 8. HAVING

The `HAVING` clause is used to filter groups based on the result of an aggregation function, similar to how `WHERE` filters rows.

- **Usage**: `SELECT column_name, AGG_FUNC(column_name) FROM table_name GROUP BY column_name HAVING condition;`
- **Example**: To find events with more than 10 tickets sold, you would use `SELECT event_id, COUNT(ticket_id) FROM tickets GROUP BY event_id HAVING COUNT(ticket_id) > 10;`.
- **Step by Step**: After `GROUP BY` segregates the data into groups, `HAVING` checks each group against the specified condition. Only groups that meet the condition are included in the final result set.

These functions and clauses are fundamental to performing calculations and analyses on grouped data in SQL, allowing for powerful data summarization and insights.
