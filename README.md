Sonaura – Premium Jewellery by Shree Om Banna Jewellers

Overview

Sonaura is a premium jewellery eCommerce web application built with React (Vite + Tailwind + Framer Motion) on the frontend and Node.js/Express with MySQL on the backend. It features live gold/silver pricing (hourly cron), JWT authentication, admin product management, and a luxurious dark theme.

Monorepo Structure

- /frontend – React app (Tailwind, Framer Motion, Router)
- /backend – Express API (JWT, bcrypt, MySQL, cron)
- /docs – Setup and deployment guides
- /admin – (Included within frontend routes)
- /database.sql – Database schema and seed entries

Quick Start

1) Backend

- Copy backend/.env.example to backend/.env and fill values.
- cd backend && npm install && npm run dev

2) Frontend

- Copy frontend/.env.example to frontend/.env and fill values.
- cd frontend && npm install && npm run dev

Environment Variables

See .env.example files in each package. Backend requires DB credentials, JWT secret, and Metals API key.

Deployment

- Frontend: Vercel/Netlify
- Backend: Render/AWS
- Database: PlanetScale/AWS RDS
- CDN: Cloudflare

License

Proprietary – Shree Om Banna Jewellers.


