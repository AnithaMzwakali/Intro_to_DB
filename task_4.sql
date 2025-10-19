import mysql.connector
from mysql.connector import errorcode

def create_database():
    connection = None
    try:
        connection = mysql.connector.connect(
            user='root',       # Replace with correct username
            password='YOUR_PASSWORD',
            host='127.0.0.1'
        )
        cursor = connection.cursor()
        cursor.execute("CREATE DATABASE IF NOT EXISTS alx_book_store")
        print("Database 'alx_book_store' created successfully!")
    except mysql.connector.Error as err:
        print(f"Error while connecting to MySQL: {err}")
    finally:
        if connection and connection.is_connected():
            cursor.close()
            connection.close()

