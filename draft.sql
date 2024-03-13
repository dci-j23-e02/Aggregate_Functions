UPDATE attendees
SET tickets = (
    SELECT array_agg(t.ticket_id)
    FROM tickets t
    WHERE t.attendee_id = (
        SELECT attendee_id
        FROM attendees
        WHERE name = 'John Doe'
    )
)
WHERE name = 'John Doe';


UPDATE attendees a
SET tickets = subquery.ticket_ids
FROM (
         SELECT t.attendee_id, array_agg(t.ticket_id) AS ticket_ids
         FROM tickets t
         GROUP BY t.attendee_id
     ) AS subquery
WHERE a.attendee_id = subquery.attendee_id;