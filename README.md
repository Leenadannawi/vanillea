# Vanilleá - Perfume and Body Care Store

## Overview
Vanilleá is an online store that offers perfumes, mists, and body care products inspired by the warm elegance of vanilla. The system allows users to log in based on their roles (Admin, Writer, Reader) and access different features based on their permissions. The project is built with **Node.js**, **PostgreSQL**, and **Vanilla JavaScript**.

### Key Features
- **Login System**: Users can log in with **Admin**, **Writer**, or **Reader** roles.
- **Role-based Dashboard**: Each role has access to different sections of the site.
  - **Admin**: Full access to all features (categories, products, orders, users, views).
  - **Writer**: Access to categories, products, and orders.
  - **Reader**: View-only access to categories, products, and orders.
- **User Management**: Track failed login attempts and lock accounts after 3 failed attempts.
- **Database Views**: Views for displaying user data and order details efficiently.

---

## Technologies Used
- **Backend**: Node.js with Express
- **Database**: PostgreSQL
- **Frontend**: HTML, CSS, Vanilla JavaScript

---

## Project Structure

### Backend
- **`server.js`**: Handles the server logic, routes, and database connection.
- **`users` table**: Stores user credentials and roles (admin, writer, reader).
- **`orders` table**: Stores order information, including which user placed the order.
- **Views**: 
  - `view_user_orders`: Displays all orders with associated user details.
  - `view_admin_summary`: Shows the number of orders per user.
  - `view_products`: Lists products and their categories.
  
### Frontend
- **Login Page**: A simple login page for users to enter their credentials.
- **Dashboard**: Role-based dashboard that directs users to different sections (categories, products, orders).
- **Views Page**: Displays user-specific data such as the order count and order total.

---

## Setup Instructions

### Step 1: Clone the Repository
Clone the repository to your local machine:

```bash
git clone https://github.com/yourusername/vanillea.git
