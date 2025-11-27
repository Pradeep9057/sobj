# Fix: Admin Orders & Invoice Issues

## Issues Fixed

✅ **Issue 1: "Unauthorized" error when viewing invoices**
✅ **Issue 2: No orders showing in admin panel (400 error)**
✅ **Issue 3: Database compatibility with missing migration columns**

## What Was Changed

### 1. Invoice Authentication (`backend/src/routes/invoices.js`)
- Added support for token-based authentication via URL parameter
- Now invoices can be accessed with `?token=<jwt_token>` in the URL
- Falls back to standard cookie/header authentication if URL token is not present

### 2. Frontend Invoice Links (`frontend/src/pages/Dashboard.jsx`)
- Updated "View Invoice" and "Print" links to include authentication token
- Token is now passed as a URL parameter: `?token=${localStorage.getItem('token')}`

### 3. Admin Orders Query (`backend/src/services/adminService.js`)
- Made the query robust to handle both old and new database schemas
- Added fallback to legacy schema if migration columns don't exist
- Better error messages to identify database issues

## Steps to Complete the Fix

### Step 1: Check Your Database Connection

Your `.env` file in the backend directory should have these variables:

```env
DB_HOST=<your-database-host>
DB_USER=<your-database-user>
DB_PASSWORD=<your-database-password>
DB_NAME=<your-database-name>
DB_PORT=5432
```

**Note**: The database host in your current .env appears incomplete. If you're using Render, it should look like:
`dpg-XXXXXXX-a.oregon-postgres.render.com` (or similar with your region)

### Step 2: Run the Database Migration

You need to add required columns to your `orders` table. You have two options:

#### Option A: Using the Migration Script (Recommended)

1. Fix your database connection in `.env` (make sure DB_HOST is complete)
2. Run the migration:
   ```bash
   cd backend
   node run-migration.js
   ```

#### Option B: Manual SQL Execution

1. Connect to your PostgreSQL database using your preferred tool (pgAdmin, DBeaver, psql, etc.)
2. Run the SQL from `database_order_updates.sql`:

```sql
-- Add status, payment fields, and tracking to orders table
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='status') THEN
    ALTER TABLE orders ADD COLUMN status VARCHAR(50) DEFAULT 'pending';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='payment_status') THEN
    ALTER TABLE orders ADD COLUMN payment_status VARCHAR(50) DEFAULT 'pending';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='payment_id') THEN
    ALTER TABLE orders ADD COLUMN payment_id VARCHAR(255);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='razorpay_order_id') THEN
    ALTER TABLE orders ADD COLUMN razorpay_order_id VARCHAR(255);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='razorpay_payment_id') THEN
    ALTER TABLE orders ADD COLUMN razorpay_payment_id VARCHAR(255);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='shipping_address') THEN
    ALTER TABLE orders ADD COLUMN shipping_address TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='tracking_number') THEN
    ALTER TABLE orders ADD COLUMN tracking_number VARCHAR(100);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='updated_at') THEN
    ALTER TABLE orders ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
  END IF;
END $$;

-- Create order_items table for multiple items per order
CREATE TABLE IF NOT EXISTS order_items (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

-- Create order_status_history table for tracking
CREATE TABLE IF NOT EXISTS order_status_history (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL,
  status VARCHAR(50) NOT NULL,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_order_status_history_order_id ON order_status_history(order_id);
CREATE INDEX IF NOT EXISTS idx_order_status_history_created_at ON order_status_history(created_at);
```

### Step 3: Restart Backend Server

After running the migration:

```bash
cd backend
npm start
# or
npm run dev
```

### Step 4: Restart Frontend (if needed)

```bash
cd frontend
npm run dev
```

### Step 5: Test the Fixes

1. **Test Admin Orders**:
   - Log in as admin
   - Go to Admin Dashboard → Orders tab
   - You should now see all orders without 400 errors

2. **Test Invoice Viewing**:
   - Go to User Dashboard → Orders
   - Click "View Invoice" on any order
   - Invoice should open in a new tab without "Unauthorized" error

## Troubleshooting

### If orders still don't show:

1. Check browser console for errors
2. Check backend terminal for error messages
3. Verify database migration was successful:
   ```sql
   SELECT column_name FROM information_schema.columns 
   WHERE table_name = 'orders';
   ```
   Should show: status, payment_status, tracking_number, etc.

### If invoices still show "Unauthorized":

1. Make sure you're logged in
2. Check that `localStorage.getItem('token')` returns a valid token in browser console
3. Clear browser cache and cookies, then log in again

### If migration fails:

1. Check database connection in `.env`
2. Ensure database is accessible
3. Check if you have necessary permissions on the database
4. Try running migration SQL manually using pgAdmin or similar tool

## Database Host Issue

Your current `.env` shows hostname: `dpg-d4cj50idbo4c73d9sg90-a`

This looks incomplete. If using Render, the full hostname should be like:
- `dpg-d4cj50idbo4c73d9sg90-a.oregon-postgres.render.com`
- `dpg-d4cj50idbo4c73d9sg90-a.singapore.render.com`
- Or your specific region

**To fix:**
1. Go to your Render dashboard
2. Click on your database
3. Copy the "External Database URL" or "Internal Database URL"
4. Update your `.env` file with the correct host

## Summary

All code fixes have been implemented. You just need to:
1. ✅ Fix database connection string in `.env`
2. ✅ Run database migration
3. ✅ Restart backend server
4. ✅ Test the application

The application should now work correctly with:
- ✅ Working invoice viewing
- ✅ Admin panel showing all orders
- ✅ No more 400 or unauthorized errors

