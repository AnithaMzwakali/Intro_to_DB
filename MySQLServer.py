import mysql.connector
from mysql.connector import errorcode
config = {
    'user': 'root',
    'password': 'your_password',
    'host': '127.0.0.1'
}
try:
    cnx = mysql.connector.connect(**config)
    cursor = cnx.cursor()
    cursor.execute("CREATE DATABASE IF NOT EXISTS alx_book_store")
    print("Database 'alx_book_store' created successfully!")
except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Error: Incorrect username or password")
    else:
        print(f"Error: {err}")
finally:
    if 'cursor' in locals():
        cursor.close()
    if 'cnx' in locals() and cnx.is_connected():
        cnx.close()
