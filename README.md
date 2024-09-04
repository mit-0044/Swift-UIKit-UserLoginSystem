# User-Login-System

## Overview

The User Login System is a simple and secure system for managing user authentication and login. This project demonstrates basic login functionalities, including user registration, login, and session management.

## Features

- User Registration: Allows users to create an account with a username and password.
- User Login: Enables registered users to log in using their credentials.
- Session Management: Maintains user sessions to keep users logged in across page refreshes.
- Password Hashing: Uses secure hashing algorithms to protect user passwords.

## Installation

To get started with the User Login System, follow these steps:

1. **Clone the Repository**

   ```bash
   git clone https://github.com/mitpatel0044/User-Login-System.git
   cd User-Login-System

Install Dependencies
Ensure you have Node.js and npm installed. Install the required packages with:

bash
Copy code
npm install
Configure Environment Variables
Create a .env file in the root directory with the following variables:

makefile
Copy code
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASS=password
SESSION_SECRET=your_secret_key
Set Up the Database
Follow the instructions in the Database Setup section to initialize your database.
Run the Application
Start the server with:

bash
Copy code
npm start
The application will be available at http://localhost:3000.
Usage

Register: Visit /register to create a new user account.
Login: Navigate to /login to sign in with your credentials.
Logout: Click on the logout link/button to end your session.
Project Structure

server.js - The main server file that sets up the application and handles routing.
routes/ - Contains route definitions for user registration, login, and other endpoints.
models/ - Includes database models and schema definitions.
views/ - Holds HTML templates for the frontend.
public/ - Contains static assets like CSS, JavaScript, and images.
Database Setup

Create Database: Set up your database according to the configuration in .env.
Run Migrations: If you have migration scripts, apply them using a command like:
bash
Copy code
npm run migrate
Seed Database: Populate your database with initial data using:
bash
Copy code
npm run seed
Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes. For major changes, open an issue first to discuss your ideas.

License

This project is licensed under the MIT License - see the LICENSE file for details.

Contact

For questions or feedback, contact mitpatel0044.

<img src="https://github.com/user-attachments/assets/dc2ca1f5-8991-43cb-8468-f9b5839f3584" width="250">
<img src="https://github.com/user-attachments/assets/05275b36-be2b-4dd5-a0ea-33d4f5424d09" width="250">
<img src="https://github.com/user-attachments/assets/7573d968-bbcb-416f-9e51-fcfeec5ea96e" width="250">
<img src="https://github.com/user-attachments/assets/22d00746-a503-4957-821c-4f2423956bfb" width="250">
<img src="https://github.com/user-attachments/assets/1316bfec-205e-4a65-aef1-d1afa3e8a4e1" width="250">
<img src="https://github.com/user-attachments/assets/80a7041f-3e64-4b97-b11a-80477e09bdbd" width="250">
<img src="https://github.com/user-attachments/assets/ac3437aa-0c0b-4197-b4d9-9e661d5dd93f" width="250">
<img src="https://github.com/user-attachments/assets/1ca13443-9598-4f9b-847b-92d5893a5e41" width="250">
<img src="https://github.com/user-attachments/assets/202422cf-913f-4ae8-b2fd-197a6bb3016c" width="250">
<img src="https://github.com/user-attachments/assets/38b0f026-cef9-4186-a550-9f87cb61b22d" width="250">

