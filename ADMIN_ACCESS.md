# Admin Panel Access Guide

## How to Login as Admin

### Step 1: Create Admin User

You need to grant admin access to a user account. There are two ways:

#### Method 1: Update Existing User to Admin

1. **Login** to your account normally at `/login`
2. Make sure you have registered and verified your email
3. Connect to your MySQL database
4. Run this SQL command (replace `your-email@example.com` with your actual email):

```sql
UPDATE users SET role='admin' WHERE email='your-email@example.com';
```

#### Method 2: Create New Admin User

1. **Sign up** for a new account at `/signup`
2. Verify your email with the OTP code
3. Run the SQL command above to grant admin access

### Step 2: Login

1. Go to `/login` (or click Login in the navbar)
2. Enter your **email** and **password**
3. Enter the **OTP code** sent to your email
4. You'll be redirected to the Dashboard

### Step 3: Access Admin Panel

Once logged in as admin:

1. Click on your **profile icon** in the navbar (top right)
2. Click **"Admin Panel"** in the dropdown menu
3. Or directly navigate to: `http://localhost:5173/admin`

## Admin Panel Features

Once you access the admin panel, you can:

- **Products Tab**: Add, edit, delete products with images
- **Metal Prices Tab**: Manage gold and silver rates
- **Orders Tab**: View all orders placed by customers
- **Analytics Tab**: View statistics and insights

## Quick SQL Commands

### Make a user admin:
```sql
UPDATE users SET role='admin' WHERE email='your-email@example.com';
```

### Check user role:
```sql
SELECT id, name, email, role FROM users WHERE email='your-email@example.com';
```

### List all admins:
```sql
SELECT id, name, email, role FROM users WHERE role='admin';
```

### Remove admin access:
```sql
UPDATE users SET role='user' WHERE email='your-email@example.com';
```

## Admin Panel URL

- **Local Development**: `http://localhost:5173/admin`
- **Production**: `https://your-domain.com/admin`

## Notes

- Admin access is protected by authentication middleware
- Only users with `role='admin'` can access the admin panel
- The admin panel link appears in your profile dropdown when logged in as admin
- Admin panel requires login and admin role verification

