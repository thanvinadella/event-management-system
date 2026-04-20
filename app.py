from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root1234",
    database="event_db"
)

cursor = db.cursor()

# =========================
# HOME
# =========================
@app.route("/")
def index():
    return render_template("index.html")


# =========================
# EVENTS
# =========================
@app.route("/events")
def events():
    query = """
    SELECT 
        e.event_id, 
        e.event_name, 
        e.event_date, 
        e.event_type, 
        v.venue_name,
        o.name
    FROM events e
    JOIN venues v ON e.venue_id = v.venue_id
    JOIN organizers o ON e.organizer_id = o.organizer_id
    """
    
    cursor.execute(query)
    data = cursor.fetchall()
    
    return render_template("events.html", events=data)


# =========================
# REGISTER
# =========================
@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        try:
            name = request.form.get("name")
            email = request.form.get("email")
            phone = request.form.get("phone")
            event_id = request.form.get("event_id")
            payment_status = request.form.get("payment_status")
            
            print(f"\n🔍 DEBUG: Received Form Data:")
            print(f"  Name: {name}")
            print(f"  Email: {email}")
            print(f"  Phone: {phone}")
            print(f"  Event ID: {event_id}")
            print(f"  Payment Status: {payment_status}")

            # CHECK IF PARTICIPANT ALREADY EXISTS
            cursor.execute(
                "SELECT participant_id FROM participants WHERE email=%s",
                (email,)
            )
            existing = cursor.fetchone()
            
            if not existing:
                print(f"✓ New participant, inserting...")
                cursor.execute(
                    "INSERT INTO participants (name, email, phone) VALUES (%s,%s,%s)",
                    (name, email, phone)
                )
                db.commit()
                print(f"✓ Participant inserted successfully")
            else:
                print(f"⚠ Participant already exists (ID: {existing[0]})")
                
            # GET PARTICIPANT ID
            cursor.execute(
                "SELECT participant_id FROM participants WHERE email=%s",
                (email,)
            )
            result = cursor.fetchone()
            if not result:
                print(f"✗ ERROR: Could not find participant after insert!")
                return "Error: Participant not found", 500
                
            participant_id = result[0]
            print(f"✓ Participant ID: {participant_id}")

            # ✅ FIXED INDENTATION HERE
            # CHECK if already registered for same event
            cursor.execute(
                "SELECT * FROM registrations WHERE participant_id=%s AND event_id=%s",
                (participant_id, event_id)
            )
            already_registered = cursor.fetchone()

            if not already_registered:
                cursor.execute(
                    "INSERT INTO registrations (participant_id, event_id) VALUES (%s,%s)",
                    (participant_id, event_id)
                )
                db.commit()
                print("✓ Registration inserted successfully")
            else:
                print("⚠ Already registered for this event")

            # PAYMENT (same as before)
            cursor.execute(
                "SELECT payment_id FROM payments WHERE participant_id=%s",
                (participant_id,)
            )
            payment_exists = cursor.fetchone()

            if not payment_exists:
                cursor.execute(
                    "INSERT INTO payments (participant_id, amount, payment_status) VALUES (%s,%s,%s)",
                    (participant_id, 500, payment_status)
                )
                db.commit()
                print(f"✓ Payment inserted successfully")
            else:
                print("⚠ Payment already exists, not inserting again")

            print(f"✅ ALL DATA SAVED SUCCESSFULLY!\n")

            return redirect(url_for('success'))
            
        except Exception as e:
            print(f"❌ ERROR in registration: {str(e)}")
            print(f"Error type: {type(e)}")
            return f"Registration Error: {str(e)}", 500

    cursor.execute("SELECT event_id, event_name FROM events")
    events = cursor.fetchall()

    return render_template("register.html", events=events)


# =========================
# SUCCESS PAGE
# =========================
@app.route("/success")
def success():
    return render_template("success.html")


# =========================
# PARTICIPANTS
# =========================
@app.route("/participants")
def participants():

    query = """
    SELECT 
    p.name, 
    p.email, 
    p.phone,
    GROUP_CONCAT(DISTINCT e.event_name SEPARATOR ', ') AS event_name
FROM participants p
LEFT JOIN registrations r ON p.participant_id = r.participant_id
LEFT JOIN events e ON r.event_id = e.event_id
GROUP BY p.participant_id, p.name, p.email, p.phone
ORDER BY p.participant_id DESC;
    """

    cursor.execute(query)
    data = cursor.fetchall()

    return render_template("participants.html", participants=data)


# =========================
# PAYMENTS
# =========================
@app.route("/payments")
def payments():
    query = """
    SELECT p.name, pay.amount, pay.payment_status
    FROM payments pay
    JOIN participants p ON pay.participant_id = p.participant_id
    ORDER BY pay.payment_id DESC
    """
    cursor.execute(query)
    data = cursor.fetchall()
    return render_template("payments.html", payments=data)


# =========================
# RUN
# =========================
if __name__ == "__main__":
    print("🚀 Flask app starting on http://localhost:5001")
    print("📝 Register page: http://localhost:5001/register")
    print("👥 View participants: http://localhost:5001/participants")
    app.run(debug=True, port=5001)