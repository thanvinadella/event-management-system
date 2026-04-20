-- ================================================================================
-- EVENT MANAGEMENT SYSTEM - COMPLETE SQL QUERIES AND VIEWS
-- ================================================================================
-- This file contains all SQL queries, views, and statements referenced in the 
-- DBMS project report. Use these for testing and data analysis.
-- ================================================================================

-- ================================================================================
-- SECTION 1: SAMPLE DATA INSERTION
-- ================================================================================

-- 1.1 Insert Organizers
INSERT INTO organizers (name, role, contact) VALUES
('SRM Tech Club', 'Technical', '9000000001'),
('Cultural Committee', 'Cultural', '9000000002'),
('Sports Council', 'Sports', '9000000003'),
('Academic Team', 'Educational', '9000000004'),
('Entertainment Club', 'Entertainment', '9000000005');

-- 1.2 Insert Venues
INSERT INTO venues (venue_name, location, capacity) VALUES
('Auditorium', 'Block A', 500),
('Seminar Hall', 'Block B', 200),
('Open Ground', 'Campus', 1000),
('Lab 1', 'Tech Block', 100),
('Gymnasium', 'Sports Block', 300);

-- 1.3 Insert Events
INSERT INTO events (event_name, event_date, event_type, venue_id, organizer_id) VALUES
('Robotics Expo', '2026-05-18', 'Technical', 1, 1),
('Cloud Computing Workshop', '2026-06-05', 'Technical', 4, 1),
('Fashion Show', '2026-05-28', 'Cultural', 3, 2),
('Cricket Tournament', '2026-06-15', 'Sports', 3, 3),
('Quiz Competition', '2026-06-26', 'Educational', 2, 4);

-- 1.4 Insert Participants
INSERT INTO participants (name, email, phone) VALUES
('Rahul Sharma', 'rahul@gmail.com', '9000000051'),
('Sneha Reddy', 'sneha@gmail.com', '9000000052'),
('Arjun Mehta', 'arjun@gmail.com', '9000000053'),
('Priya Nair', 'priya@gmail.com', '9000000054'),
('Kiran Kumar', 'kiran@gmail.com', '9000000055');

-- 1.5 Insert Registrations
INSERT INTO registrations (participant_id, event_id) VALUES
(1, 1),  -- Rahul registers for Robotics Expo
(1, 2),  -- Rahul registers for Cloud Computing Workshop
(2, 1),  -- Sneha registers for Robotics Expo
(3, 3),  -- Arjun registers for Fashion Show
(4, 4),  -- Priya registers for Cricket Tournament
(5, 5);  -- Kiran registers for Quiz Competition

-- 1.6 Insert Payments
INSERT INTO payments (participant_id, amount, payment_status) VALUES
(1, 500, 'Paid'),
(2, 500, 'Paid'),
(3, 500, 'Pending'),
(4, 500, 'Paid'),
(5, 500, 'Pending');

-- ================================================================================
-- SECTION 2: SIMPLE SELECT QUERIES
-- ================================================================================

-- 2.1 List all events with their details
SELECT * FROM events;

-- 2.2 List all participants
SELECT * FROM participants;

-- 2.3 List all organizers
SELECT * FROM organizers;

-- 2.4 List all venues
SELECT * FROM venues;

-- ================================================================================
-- SECTION 3: QUERIES WITH JOIN
-- ================================================================================

-- 3.1 List all events with organizer names and venue names
SELECT 
    e.event_id,
    e.event_name,
    e.event_date,
    e.event_type,
    o.name AS organizer_name,
    v.venue_name,
    v.capacity
FROM events e
JOIN organizers o ON e.organizer_id = o.organizer_id
JOIN venues v ON e.venue_id = v.venue_id;

-- 3.2 Find all participants registered for Robotics Expo with their payment status
SELECT 
    p.participant_id,
    p.name,
    e.event_name,
    pa.payment_status,
    pa.amount
FROM participants p
JOIN registrations r ON p.participant_id = r.participant_id
JOIN events e ON r.event_id = e.event_id
JOIN payments pa ON p.participant_id = pa.participant_id
WHERE e.event_name = 'Robotics Expo';

-- 3.3 Find which events a specific participant has registered for
SELECT 
    p.name,
    e.event_name,
    e.event_date,
    e.event_type
FROM participants p
LEFT JOIN registrations r ON p.participant_id = r.participant_id
LEFT JOIN events e ON r.event_id = e.event_id
WHERE p.name = 'Rahul Sharma';

-- 3.4 List all participants in each event with payment details
SELECT 
    e.event_name,
    p.name AS participant_name,
    pa.payment_status,
    pa.amount
FROM events e
JOIN registrations r ON e.event_id = r.event_id
JOIN participants p ON r.participant_id = p.participant_id
JOIN payments pa ON p.participant_id = pa.participant_id
ORDER BY e.event_name, p.name;

-- ================================================================================
-- SECTION 4: QUERIES WITH AGGREGATE FUNCTIONS
-- ================================================================================

-- 4.1 Count participants registered for each event
SELECT 
    e.event_name,
    COUNT(r.participant_id) AS total_registrations
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY e.event_id, e.event_name
ORDER BY total_registrations DESC;

-- 4.2 Calculate payment statistics
SELECT 
    COUNT(CASE WHEN payment_status = 'Paid' THEN 1 END) AS paid_count,
    COUNT(CASE WHEN payment_status = 'Pending' THEN 1 END) AS pending_count,
    SUM(CASE WHEN payment_status = 'Paid' THEN amount ELSE 0 END) AS total_revenue,
    AVG(amount) AS average_payment
FROM payments;

-- 4.3 Find organizer with maximum number of events
SELECT 
    o.name,
    COUNT(e.event_id) AS event_count
FROM organizers o
LEFT JOIN events e ON o.organizer_id = e.organizer_id
GROUP BY o.organizer_id, o.name
ORDER BY event_count DESC
LIMIT 1;

-- 4.4 Find average number of participants per event type
SELECT 
    e.event_type,
    COUNT(DISTINCT e.event_id) AS number_of_events,
    COUNT(DISTINCT r.participant_id) AS total_participants,
    ROUND(COUNT(DISTINCT r.participant_id) / COUNT(DISTINCT e.event_id), 2) AS avg_participants_per_event
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY e.event_type;

-- 4.5 Find total revenue by event type
SELECT 
    e.event_type,
    SUM(pa.amount) AS total_revenue,
    COUNT(pa.payment_id) AS number_of_payments
FROM events e
JOIN registrations r ON e.event_id = r.event_id
JOIN payments pa ON r.participant_id = pa.participant_id
WHERE pa.payment_status = 'Paid'
GROUP BY e.event_type;

-- ================================================================================
-- SECTION 5: QUERIES WITH SUBQUERIES
-- ================================================================================

-- 5.1 Find participants who registered for more than 1 event
SELECT 
    p.participant_id,
    p.name,
    COUNT(r.event_id) AS events_registered
FROM participants p
JOIN registrations r ON p.participant_id = r.participant_id
GROUP BY p.participant_id, p.name
HAVING COUNT(r.event_id) > 1;

-- 5.2 Find unpaid participants registered for Technical events
SELECT 
    p.name,
    e.event_name
FROM participants p
WHERE p.participant_id IN (
    SELECT participant_id 
    FROM payments 
    WHERE payment_status = 'Pending'
)
AND p.participant_id IN (
    SELECT r.participant_id 
    FROM registrations r
    JOIN events e ON r.event_id = e.event_id
    WHERE e.event_type = 'Technical'
);

-- 5.3 Find events with registration count above average
SELECT 
    e.event_name,
    COUNT(r.participant_id) AS registration_count,
    (SELECT AVG(count_per_event) FROM (
        SELECT COUNT(*) as count_per_event 
        FROM registrations 
        GROUP BY event_id
    ) as avg_calc) AS avg_registrations
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY e.event_id, e.event_name
HAVING COUNT(r.participant_id) > (
    SELECT AVG(count_per_event) FROM (
        SELECT COUNT(*) as count_per_event 
        FROM registrations 
        GROUP BY event_id
    ) as subquery
);

-- 5.4 Find participants with no payment records
SELECT 
    p.participant_id,
    p.name,
    p.email
FROM participants p
WHERE p.participant_id NOT IN (
    SELECT DISTINCT participant_id 
    FROM payments
);

-- 5.5 Find top 3 most popular events by registration
SELECT TOP 3
    e.event_name,
    COUNT(r.participant_id) AS registration_count
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY e.event_id, e.event_name
ORDER BY registration_count DESC;
-- Note: For MySQL, use LIMIT 3 instead of TOP 3

-- ================================================================================
-- SECTION 6: VIEWS
-- ================================================================================

-- 6.1 VIEW 1: Event Summary View
-- Shows all events with key metrics including organizer, venue, and availability
CREATE VIEW event_summary AS
SELECT 
    e.event_id,
    e.event_name,
    e.event_date,
    e.event_type,
    o.name AS organizer,
    v.venue_name,
    COUNT(r.participant_id) AS total_participants,
    v.capacity,
    (v.capacity - COUNT(r.participant_id)) AS seats_available
FROM events e
JOIN organizers o ON e.organizer_id = o.organizer_id
JOIN venues v ON e.venue_id = v.venue_id
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY e.event_id, e.event_name, e.event_date, e.event_type, 
         o.name, v.venue_name, v.capacity;

-- Usage: SELECT * FROM event_summary;

-- 6.2 VIEW 2: Participant Payment Report View
-- Shows participant details with payment status and registered events
CREATE VIEW participant_payment_report AS
SELECT 
    p.participant_id,
    p.name,
    p.email,
    COUNT(r.event_id) AS events_registered,
    pa.amount,
    pa.payment_status,
    CASE 
        WHEN pa.payment_status = 'Paid' THEN 'Complete'
        WHEN pa.payment_status = 'Pending' THEN 'Action Required'
    END AS status_label,
    GROUP_CONCAT(e.event_name SEPARATOR ', ') AS registered_events
FROM participants p
LEFT JOIN registrations r ON p.participant_id = r.participant_id
LEFT JOIN events e ON r.event_id = e.event_id
LEFT JOIN payments pa ON p.participant_id = pa.participant_id
GROUP BY p.participant_id, p.name, p.email, pa.amount, pa.payment_status;

-- Usage: SELECT * FROM participant_payment_report;

-- 6.3 VIEW 3: Organizer Statistics View
-- Shows statistics for each organizer
CREATE VIEW organizer_statistics AS
SELECT 
    o.organizer_id,
    o.name AS organizer_name,
    o.role,
    COUNT(DISTINCT e.event_id) AS total_events,
    COUNT(DISTINCT r.participant_id) AS total_participants,
    SUM(pa.amount) AS total_revenue
FROM organizers o
LEFT JOIN events e ON o.organizer_id = e.organizer_id
LEFT JOIN registrations r ON e.event_id = r.event_id
LEFT JOIN payments pa ON r.participant_id = pa.participant_id
GROUP BY o.organizer_id, o.name, o.role;

-- Usage: SELECT * FROM organizer_statistics WHERE total_events > 0;

-- 6.4 VIEW 4: Venue Utilization View (OPTIONAL)
-- Shows venue utilization percentage and event details
CREATE VIEW venue_utilization AS
SELECT 
    v.venue_id,
    v.venue_name,
    v.capacity,
    COUNT(DISTINCT e.event_id) AS events_hosted,
    COUNT(r.participant_id) AS total_participants,
    ROUND((COUNT(r.participant_id) / v.capacity) * 100, 2) AS utilization_percentage
FROM venues v
LEFT JOIN events e ON v.venue_id = e.venue_id
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY v.venue_id, v.venue_name, v.capacity;

-- Usage: SELECT * FROM venue_utilization;

-- ================================================================================
-- SECTION 7: USEFUL QUERIES FOR REPORTING
-- ================================================================================

-- 7.1 Event participation report
SELECT 
    e.event_name,
    e.event_date,
    e.event_type,
    o.name AS organizer,
    COUNT(DISTINCT r.participant_id) AS participants,
    COUNT(DISTINCT CASE WHEN pa.payment_status = 'Paid' THEN pa.participant_id END) AS paid,
    COUNT(DISTINCT CASE WHEN pa.payment_status = 'Pending' THEN pa.participant_id END) AS pending
FROM events e
JOIN organizers o ON e.organizer_id = o.organizer_id
LEFT JOIN registrations r ON e.event_id = r.event_id
LEFT JOIN payments pa ON r.participant_id = pa.participant_id
GROUP BY e.event_id, e.event_name, e.event_date, e.event_type, o.name
ORDER BY e.event_date;

-- 7.2 Pending payments reminder list
SELECT 
    p.participant_id,
    p.name,
    p.email,
    p.phone,
    pa.payment_id,
    pa.amount,
    COUNT(r.event_id) AS events_registered
FROM participants p
JOIN payments pa ON p.participant_id = pa.participant_id
JOIN registrations r ON p.participant_id = r.participant_id
WHERE pa.payment_status = 'Pending'
GROUP BY p.participant_id, p.name, p.email, p.phone, pa.payment_id, pa.amount;

-- 7.3 Check if participant is eligible for refund (no registrations within 7 days)
SELECT 
    p.participant_id,
    p.name,
    pa.amount,
    pa.payment_status,
    COUNT(r.event_id) AS upcoming_events
FROM participants p
JOIN payments pa ON p.participant_id = pa.participant_id
LEFT JOIN registrations r ON p.participant_id = r.participant_id
LEFT JOIN events e ON r.event_id = e.event_id 
    AND e.event_date >= DATE_ADD(CURDATE(), INTERVAL 7 DAY)
WHERE pa.payment_status = 'Paid'
GROUP BY p.participant_id, p.name, pa.amount, pa.payment_status
HAVING COUNT(r.event_id) = 0;

-- 7.4 Venue capacity warning (venues over 80% capacity)
SELECT 
    v.venue_name,
    v.capacity,
    COUNT(r.participant_id) AS current_registrations,
    ROUND((COUNT(r.participant_id) / v.capacity) * 100, 2) AS utilization_percent,
    CASE 
        WHEN (COUNT(r.participant_id) / v.capacity) > 0.8 THEN 'Capacity Alert!'
        ELSE 'Normal'
    END AS status
FROM venues v
LEFT JOIN events e ON v.venue_id = e.venue_id
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY v.venue_id, v.venue_name, v.capacity
HAVING utilization_percent > 80;

-- ================================================================================
-- END OF SQL QUERIES AND VIEWS FILE
-- ================================================================================
