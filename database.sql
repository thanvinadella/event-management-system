-- ===============================
-- RESET DATABASE
-- ===============================
DROP DATABASE IF EXISTS event_db;
CREATE DATABASE event_db;
USE event_db;

-- ===============================
-- ORGANIZERS
-- ===============================
CREATE TABLE organizers (
    organizer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50),
    contact VARCHAR(15) UNIQUE
);

INSERT INTO organizers (name, role, contact) VALUES
('SRM Tech Club', 'Technical', '9000000001'),
('Cultural Committee', 'Cultural', '9000000002'),
('Sports Council', 'Sports', '9000000003');

-- ===============================
-- VENUES
-- ===============================
CREATE TABLE venues (
    venue_id INT AUTO_INCREMENT PRIMARY KEY,
    venue_name VARCHAR(100),
    location VARCHAR(100),
    capacity INT
);

INSERT INTO venues VALUES
(1,'Auditorium','Block A',500),
(2,'Seminar Hall','Block B',200),
(3,'Open Ground','Campus',1000),
(4,'Lab 1','Tech Block',100);

-- ===============================
-- EVENTS
-- ===============================
CREATE TABLE events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(100),
    event_date DATE,
    event_type VARCHAR(50),
    venue_id INT,
    organizer_id INT,
    FOREIGN KEY (venue_id) REFERENCES venues(venue_id),
    FOREIGN KEY (organizer_id) REFERENCES organizers(organizer_id)
);

INSERT INTO events (event_name,event_date,event_type,venue_id,organizer_id) VALUES

-- TECH (Organizer 1)
('Robotics Expo','2026-05-18','Technical',1,1),
('Cloud Computing Workshop','2026-06-05','Technical',4,1),
('Data Science Bootcamp','2026-06-08','Technical',4,1),
('Blockchain Seminar','2026-06-12','Technical',2,1),

-- CULTURAL (Organizer 2)
('Fashion Show','2026-05-28','Cultural',3,2),
('Stand-up Comedy Night','2026-06-02','Cultural',2,2),
('Art Exhibition','2026-06-09','Creative',2,2),
('Poetry Slam','2026-06-14','Cultural',3,2),

-- SPORTS (Organizer 3)
('Cricket Tournament','2026-06-15','Sports',3,3),
('Football League','2026-06-18','Sports',3,3),
('Basketball Match','2026-06-20','Sports',3,3),
('Marathon Run','2026-06-25','Sports',3,3),

-- MIXED / FUN EVENTS
('Gaming Night','2026-06-22','Entertainment',3,3),
('Quiz Competition','2026-06-26','Educational',2,1),
('Startup Networking','2026-06-28','Business',2,1),
('Photography Walk','2026-07-02','Creative',3,2);

-- ===============================
-- PARTICIPANTS (32 CLEAN)
-- ===============================
CREATE TABLE participants (
    participant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15) UNIQUE
);

INSERT INTO participants (name,email,phone) VALUES
('Rahul Sharma','rahul@gmail.com','9000000001'),
('Sneha Reddy','sneha@gmail.com','9000000002'),
('Arjun Mehta','arjun@gmail.com','9000000003'),
('Priya Nair','priya@gmail.com','9000000004'),
('Kiran Kumar','kiran@gmail.com','9000000005'),
('Aman Verma','aman@gmail.com','9000000006'),
('Neha Kapoor','neha@gmail.com','9000000007'),
('Rohit Singh','rohit@gmail.com','9000000008'),
('Anjali Sharma','anjali@gmail.com','9000000009'),
('Vikram Rao','vikram@gmail.com','9000000010'),
('Pooja Das','pooja@gmail.com','9000000011'),
('Siddharth Jain','sid@gmail.com','9000000012'),
('Meera Iyer','meera@gmail.com','9000000013'),
('Karthik Reddy','karthik@gmail.com','9000000014'),
('Divya Patel','divya@gmail.com','9000000015'),
('Aditya Kumar','aditya@gmail.com','9000000016'),
('Shreya Gupta','shreya@gmail.com','9000000017'),
('Harsh Agarwal','harsh@gmail.com','9000000018'),
('Nikita Singh','nikita@gmail.com','9000000019'),
('Yash Mehta','yash@gmail.com','9000000020'),
('Ritika Nair','ritika@gmail.com','9000000021'),
('Manish Pandey','manish@gmail.com','9000000022'),
('Kavya Reddy','kavya@gmail.com','9000000023'),
('Deepak Chauhan','deepak@gmail.com','9000000024'),
('Sanya Malhotra','sanya@gmail.com','9000000025'),
('Sanjana','sanjana@gmail.com','9000000026'),
('Varun','varun@gmail.com','9000000027'),
('Teja','teja@gmail.com','9000000028'),
('Rakesh','rakesh@gmail.com','9000000029'),
('Keerthi','keerthi@gmail.com','9000000030'),
('Bhavya','bhavya@gmail.com','9000000031'),
('Tarun','tarun@gmail.com','9000000032');

-- ===============================
-- REGISTRATIONS (NO DUPLICATES)
-- ===============================
CREATE TABLE registrations (
    reg_id INT AUTO_INCREMENT PRIMARY KEY,
    participant_id INT,
    event_id INT,
    UNIQUE(participant_id,event_id),
    FOREIGN KEY (participant_id) REFERENCES participants(participant_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id)
);
INSERT INTO registrations (participant_id,event_id) VALUES
(1,1),(1,2),
(2,1),
(3,2),
(4,3),(4,4),
(5,5),
(6,1),(6,6),
(7,2),
(8,3),(8,5),
(9,4),(9,6),
(10,7),
(11,1),
(12,2),
(13,3),
(14,4),
(15,5),
(16,6),
(17,7),
(18,8),
(19,9),
(20,10),
(21,11),
(22,12),
(23,13),
(24,14),
(25,15),
(26,16),
(27,1),
(28,2),
(29,3),
(30,4),
(31,5),
(32,6);

-- ===============================
-- PAYMENTS
-- ===============================
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    participant_id INT,
    amount DECIMAL(10,2),
    payment_status ENUM('Paid','Pending'),
    FOREIGN KEY (participant_id) REFERENCES participants(participant_id)
);

INSERT INTO payments (participant_id,amount,payment_status) VALUES
(1,500,'Paid'),
(2,500,'Paid'),
(3,500,'Pending'),
(4,500,'Paid'),
(5,500,'Paid'),
(6,500,'Paid'),
(7,500,'Paid'),
(8,500,'Pending'),
(9,500,'Paid'),
(10,500,'Paid'),
(11,500,'Paid'),
(12,500,'Pending'),
(13,500,'Paid'),
(14,500,'Paid'),
(15,500,'Paid'),
(16,500,'Pending'),
(17,500,'Paid'),
(18,500,'Paid'),
(19,500,'Pending'),
(20,500,'Paid'),
(21,500,'Paid'),
(22,500,'Paid'),
(23,500,'Pending'),
(24,500,'Paid'),
(25,550,'Paid'),
(26,500,'Paid'),
(27,500,'Paid'),
(28,500,'Pending'),
(29,500,'Paid'),
(30,500,'Paid'),
(31,500,'Paid'),
(32,500,'Pending');



