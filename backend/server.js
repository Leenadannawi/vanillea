const express = require('express');
const { Client } = require('pg');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const PORT = 3001;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// PostgreSQL connection settings
const client = new Client({
    host: 'localhost',
    user: 'postgres', // your PostgreSQL username
    password: 'postgres123', // your PostgreSQL password
    database: 'mydb', // the name of your database
    port: 5432, // default PostgreSQL port
});

// Connect to PostgreSQL
client.connect(err => {
    if (err) {
        console.error('Connection error', err.stack);
    } else {
        console.log('Connected to PostgreSQL');
    }
});

// Routes
app.get('/categories', async (req, res) => {
    try {
        const result = await client.query('SELECT * FROM categories');
        res.json(result.rows); // Return categories as JSON
    } catch (err) {
        console.error(err);
        res.status(500).send('Error fetching categories');
    }
});
app.get('/views', async (req, res) => {
    try {
        const result = await client.query('SELECT * FROM view_user_orders');
        res.json(result.rows); // Return the view data as JSON
    } catch (err) {
        console.error(err);
        res.status(500).send('Error fetching views');
    }
});

app.get('/users', async (req, res) => {
    try {
        const result = await client.query('SELECT * FROM users');
        res.json(result.rows); // Return users as JSON
    } catch (err) {
        console.error(err);
        res.status(500).send('Error fetching users');
    }
});


app.get('/products', async (req, res) => {
    try {
        const result = await client.query('SELECT * FROM products');
        res.json(result.rows); // Return products as JSON
    } catch (err) {
        console.error(err);
        res.status(500).send('Error fetching products');
    }
});
// Route to fetch all orders
app.get('/orders', async (req, res) => {
    try {
        const result = await client.query('SELECT * FROM orders');
        res.json(result.rows); // Return orders as JSON
    } catch (err) {
        console.error(err);
        res.status(500).send('Error fetching orders');
    }
});

// POST route for login
app.post('/login', async (req, res) => {
    const { username, password } = req.body;

    try {
        // Query to find the user
        const result = await client.query('SELECT * FROM users WHERE username = $1', [username]);

        if (result.rows.length === 0) {
            return res.status(401).json({ success: false, message: 'Invalid username or password' });
        }

        const user = result.rows[0];

        // Check if account is locked
        if (user.failed_login_attempts >= 3) {
            return res.status(403).json({ success: false, message: 'Account locked due to too many failed login attempts' });
        }

        // Check if password matches
        if (user.password !== password) {
            // Increment failed login attempts
            await client.query('UPDATE users SET failed_login_attempts = failed_login_attempts + 1 WHERE user_id = $1', [user.user_id]);
            return res.status(401).json({ success: false, message: 'Invalid username or password' });
        }

        // Reset failed login attempts on successful login
        await client.query('UPDATE users SET failed_login_attempts = 0 WHERE user_id = $1', [user.user_id]);

        res.json({
            success: true,
            message: 'Login successful!',
            role: user.role,
        });

    } catch (err) {
        console.error(err);
        res.status(500).send('Error logging in');
    }
});


// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});