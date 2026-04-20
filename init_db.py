import mysql.connector

# Connect to MySQL server (without database)
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root1234"
)

cursor = db.cursor()

# Read SQL file
with open('database.sql', 'r') as f:
    sql_content = f.read()

# Split by semicolon and execute each statement
statements = sql_content.split(';')

for statement in statements:
    statement = statement.strip()
    if statement:
        try:
            cursor.execute(statement)
            db.commit()
            print(f"✓ Executed: {statement[:60]}...")
        except Exception as e:
            print(f"✗ Error: {e}")

cursor.close()
db.close()

print("\n✅ Database initialized successfully!")
