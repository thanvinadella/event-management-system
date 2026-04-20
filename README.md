# Event Management System

A web-based Event Management System developed using Flask and MySQL to manage events, participant registrations, and payment tracking in a structured and efficient way.

---

## 📌 Features
- View and manage event details
- Register participants for events
- Track participant information (name, email, phone)
- Maintain payment status (Paid/Pending)
- Prevent duplicate registrations using database constraints
- Dynamic data handling using MySQL

---

## 🛠️ Technologies Used
- Python (Flask)
- MySQL
- HTML, CSS

---

## 📂 Project Structure
- app.py → Main backend application
- templates/ → HTML pages (UI)
- static/ → CSS and images
- database.sql → Database schema and sample data
- QUERIES_AND_VIEWS.sql → SQL queriesi and views
- init_db.py → Database setup script
- view_database.py → Utility script to view data

---

## ⚙️ How to Run
1. Import the database using `database.sql`

2. Run the Flask application:
```bash
python3 app.py
```

3. Open your browser and go to:
http://localhost:5001
---

## 🗄️ Database Design
- Designed using Entity-Relationship (ER) model
- Converted into relational schema
- Normalized up to Third Normal Form (3NF)
- Includes entities such as Events, Participants, Registrations, Payments, Organizers, and Venues

---

## 📊 SQL Operations
- JOIN queries to combine data from multiple tables
- Aggregate functions like COUNT and SUM
- Subqueries for advanced data retrieval
- Views to simplify complex queries

---

## 🎯 Objective
To develop a database-driven system that simplifies event management and ensures efficient storage, retrieval, and management of event-related data.
