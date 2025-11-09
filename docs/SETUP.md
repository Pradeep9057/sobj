Sonaura Setup

Prerequisites

- Node.js 18+
- MySQL 8+
- Git

1) Database

- Create database `sonaura`
- Run `database.sql` in your MySQL instance

2) Backend

- Copy `backend/.env.example` to `backend/.env` and fill values
- Install and run:

```
cd backend
npm install
npm run dev
```

- API available at `http://localhost:5000`

3) Frontend

- Copy `frontend/.env.example` to `frontend/.env` with `VITE_API_BASE=http://localhost:5000`
- Install and run:

```
cd frontend
npm install
npm run dev
```

- Site at `http://localhost:5173`

4) Live Prices

**Environment Variables:**
```env
GOLD_API_KEY=your-api-key-here
GOLD_API_PROVIDER=goldapi  # Options: 'metals-api' or 'goldapi'
```

**For GoldAPI.io (recommended):**
- Set `GOLD_API_PROVIDER=goldapi`
- Set `GOLD_API_KEY=goldapi-xxxxx` (your API key)
- API endpoint: `https://www.goldapi.io/api/XAU/INR`

**For Metals-API:**
- Set `GOLD_API_PROVIDER=metals-api`
- Set `GOLD_API_KEY=your-access-key`

**Testing & Troubleshooting:**
- Check price update status: `GET http://localhost:5000/api/prices/status`
- Test API connection (admin only): `GET http://localhost:5000/api/prices/test-api`
- Manual refresh (admin only): `POST http://localhost:5000/api/prices/refresh`
- Cron runs hourly at minute 0; also runs on server start
- Check backend console for error messages (should show ❌ or ✅)

**Common Issues:**
- Missing API key: Set `GOLD_API_KEY` in `backend/.env`
- Invalid API key: Verify key is correct and has quota remaining
- Wrong provider: Use `goldapi` for GoldAPI.io, `metals-api` for Metals-API
- API errors: Check backend console for specific error messages
- Admin can manually refresh from Admin Panel > Metal Prices > "Refresh Prices Now" button

5) Deployment

- Frontend: Vercel/Netlify, set `VITE_API_BASE` to your backend URL
- Backend: Render/AWS EC2, set env vars
- DB: PlanetScale/AWS RDS
- CDN: Cloudflare

Admin Access

- Make a user admin:

```
UPDATE users SET role='admin' WHERE email='you@example.com';
```


