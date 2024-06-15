import pymysql
import pywhatkit as kit
import time

# Database connection parameters
db_host = 'localhost'
db_user = 'root'
db_password = 'param1903'
db_name = 'ekalavya'

# Function to send a WhatsApp message
def send_whatsapp_message(contact_number, message):
    # Format contact number for pywhatkit
    contact_number = f"+{contact_number}"
    # Send the message at the next minute
    current_hour = int(time.strftime("%H"))
    current_minute = int(time.strftime("%M")) + 1
    kit.sendwhatmsg_instantly(contact_number, message)

try:
    # Connect to the database
    connection = pymysql.connect(
        host=db_host,
        user=db_user,
        password=db_password,
        database=db_name
    )

    # Create a cursor object
    cursor = connection.cursor()

    # SQL query to retrieve data based on criteria
    query = """
    SELECT s.student_id, s.contact_number, s.name, p.attendance, p.recent_test_score, p.courses_completed
    FROM performance p
    JOIN student s ON p.student_id = s.student_id
    WHERE p.attendance < 60
    #    OR p.recent_test_score <= 40
    #    OR p.courses_completed < 3
    """

    # Execute the query
    cursor.execute(query)

    # Fetch all rows from the executed query
    results = cursor.fetchall()

    # Process each result and send a WhatsApp message
    for row in results:
        student_id, contact_number, name, attendance, recent_test_score, courses_completed = row
        messages = []
        if attendance < 60:
            messages.append(f"Your attendance is {attendance}%, which is below the required 60%.")
        if recent_test_score <= 40:
            messages.append(f"Your recent test score is {recent_test_score}%, which is below or equal to the required 40%.")
        if courses_completed < 3:
            messages.append(f"You have completed {courses_completed} courses, which is less than the required 3 courses.")

        # Construct the message
        if messages:
            message_body = f"Hello {name},\n\n" + "\n".join(messages) + "\n\nPlease take the necessary actions to improve your performance."

            # Send the WhatsApp message
            send_whatsapp_message(contact_number, message_body)
            print(f"Message sent to {name} at {contact_number}")

except pymysql.MySQLError as e:
    print(f"Error connecting to database: {e}")

finally:
    # Close the cursor and connection
    if cursor:
        cursor.close()
    if connection:
        connection.close()
