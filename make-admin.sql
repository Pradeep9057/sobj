-- SQL Script to Grant Admin Access
-- Replace 'your-email@example.com' with your actual email address

-- Option 1: Update existing user to admin
UPDATE users SET role='admin' WHERE email='your-email@example.com';

-- Option 2: Create a new admin user (if email doesn't exist)
-- First, register normally through the signup page, then run:
-- UPDATE users SET role='admin' WHERE email='your-email@example.com';

-- To verify the user is now admin:
SELECT id, name, email, role FROM users WHERE email='your-email@example.com';

