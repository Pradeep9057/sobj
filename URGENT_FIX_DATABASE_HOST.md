# 🚨 URGENT: Fix Database Connection

## The Problem

Your `backend/.env` file has an **incomplete database hostname**:

```
❌ Current: dpg-d4cj50idbo4c73d9sg90-a
✅ Should be: dpg-d4cj50idbo4c73d9sg90-a.oregon-postgres.render.com (or your region)
```

## How to Fix

### Step 1: Get the Correct Database URL from Render

1. Go to https://dashboard.render.com/
2. Click on your database (should be named "sonaura" or similar)
3. Scroll down to find **"External Database URL"** or **"Connection String"**
4. It will look something like:
   ```
   postgres://sonaura_user:Xw...@dpg-d4cj50idbo4c73d9sg90-a.oregon-postgres.render.com/sonaura
   ```

### Step 2: Update Your backend/.env File

Open `backend/.env` and update the `DB_HOST` line:

```env
# Change this line:
DB_HOST=dpg-d4cj50idbo4c73d9sg90-a

# To this (with your full hostname from Render):
DB_HOST=dpg-d4cj50idbo4c73d9sg90-a.oregon-postgres.render.com
```

Or use the full connection string format:
```env
DATABASE_URL=postgres://sonaura_user:your_password@dpg-d4cj50idbo4c73d9sg90-a.oregon-postgres.render.com/sonaura
```

### Step 3: Test the Connection

```bash
cd backend
node test-db-connection.js
```

You should see:
```
✅ Successfully connected to database!
```

### Step 4: Run the Migration

```bash
node run-migration.js
```

### Step 5: Start Your Backend

```bash
npm start
```

## Quick Commands

After fixing the database host in `.env`, run these in order:

```bash
cd backend
node test-db-connection.js   # Should succeed
node run-migration.js         # Adds required columns
npm start                     # Start the server
```

## What This Will Fix

✅ Admin panel will show orders (no more 400 error)
✅ Invoices will be viewable (no more "Unauthorized")
✅ Order management will work properly

## Still Having Issues?

If you can't find the database URL:
1. Check Render dashboard → Your Database → "Info" tab
2. Look for "External Connection String" or "PSQL Command"
3. Copy the hostname from there (the part after `@` and before the `/`)

Example from connection string:
```
postgres://user:pass@THIS-IS-THE-HOST/dbname
                     ↑
                     Copy this part
```

