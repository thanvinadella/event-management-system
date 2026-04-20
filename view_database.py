import mysql.connector

# Connect to database
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root1234",
    database="event_db"
)

cursor = db.cursor()

print("\n" + "="*80)
print("DATABASE: event_db - ALL STORED DATA")
print("="*80)

# 1. ORGANIZERS
print("\n📋 TABLE: ORGANIZERS")
print("-" * 80)
cursor.execute("SELECT * FROM organizers")
organizers = cursor.fetchall()
if organizers:
    for row in organizers:
        print(f"ID: {row[0]} | Name: {row[1]} | Role: {row[2]} | Contact: {row[3]}")
else:
    print("No data")

# 2. VENUES
print("\n🏢 TABLE: VENUES")
print("-" * 80)
cursor.execute("SELECT * FROM venues")
venues = cursor.fetchall()
if venues:
    for row in venues:
        print(f"ID: {row[0]} | Name: {row[1]} | Location: {row[2]} | Capacity: {row[3]}")
else:
    print("No data")

# 3. EVENTS
print("\n🎪 TABLE: EVENTS")
print("-" * 80)
cursor.execute("""
    SELECT e.event_id, e.event_name, e.event_date, e.event_type, 
           v.venue_name, o.name 
    FROM events e
    JOIN venues v ON e.venue_id = v.venue_id
    JOIN organizers o ON e.organizer_id = o.organizer_id
""")
events = cursor.fetchall()
if events:
    for row in events:
        print(f"ID: {row[0]} | Event: {row[1]} | Date: {row[2]} | Type: {row[3]} | Venue: {row[4]} | Organizer: {row[5]}")
else:
    print("No data")

# 4. PARTICIPANTS
print("\n👥 TABLE: PARTICIPANTS")
print("-" * 80)
cursor.execute("SELECT * FROM participants")
participants = cursor.fetchall()
if participants:
    for row in participants:
        print(f"ID: {row[0]} | Name: {row[1]} | Email: {row[2]} | Phone: {row[3]}")
else:
    print("No data")

# 5. REGISTRATIONS
print("\n📝 TABLE: REGISTRATIONS")
print("-" * 80)
cursor.execute("""
    SELECT r.reg_id, p.name, e.event_name, r.reg_date
    FROM registrations r
    JOIN participants p ON r.participant_id = p.participant_id
    JOIN events e ON r.event_id = e.event_id
""")
registrations = cursor.fetchall()
if registrations:
    for row in registrations:
        print(f"Reg ID: {row[0]} | Participant: {row[1]} | Event: {row[2]} | Date: {row[3]}")
else:
    print("No data")

# 6. PAYMENTS
print("\n💳 TABLE: PAYMENTS")
print("-" * 80)
cursor.execute("""
    SELECT pay.payment_id, p.name, pay.amount, pay.payment_status, pay.payment_date
    FROM payments pay
    JOIN participants p ON pay.participant_id = p.participant_id
""")
payments = cursor.fetchall()
if payments:
    for row in payments:
        print(f"Payment ID: {row[0]} | Participant: {row[1]} | Amount: ₹{row[2]} | Status: {row[3]} | Date: {row[4]}")
else:
    print("No data")

print("\n" + "="*80 + "\n")

cursor.close()
db.close()
