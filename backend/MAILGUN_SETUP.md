# Mailgun Email Setup Guide

## Problem
Gmail SMTP is timing out (ETIMEDOUT) - connection cannot be established. This is common when:
- **Render blocks SMTP ports** (25, 587, 465) - This is the main issue!
- ISP/Network blocks SMTP port 587
- Gmail rate limiting
- Firewall restrictions
- Deployed on restrictive hosting

## Solution: Use Mailgun HTTP API (NOT SMTP)
**Important**: Render blocks SMTP connections, so we use Mailgun's **HTTP API** instead of SMTP. This uses HTTPS (port 443) which is never blocked.

Mailgun is a dedicated email service provider that is specifically designed for transactional emails.

## ✅ Step 1: Create Mailgun Account

1. Go to: https://www.mailgun.com
2. Click "Sign Up" 
3. Create a free account (includes 1000 emails/month)
4. Verify your email

## ✅ Step 2: Get Your Mailgun API Credentials

1. After login, go to **Dashboard**
2. Look for your **Sandbox Domain** (should look like: `sandboxe326c1bc9ece48b8ad00df3fb6e8b3e5.mailgun.org`)
3. Click on the domain name to open details
4. Go to **API Keys** section (or **Settings** → **API Keys**)
5. You'll see:
   - **Private API Key**: Copy this (looks like: `abc123def456ghi789jkl012mno345pq`)
   - **Domain**: Your sandbox domain (e.g., `sandboxe326c1bc9ece48b8ad00df3fb6e8b3e5.mailgun.org`)

## ✅ Step 3: Update Render Environment Variables

**For Render Deployment (RECOMMENDED - Uses HTTP API):**

Go to your Render dashboard → Your Backend Service → Environment → Add these variables:

```env
MAILGUN_API_KEY=abc123def456ghi789jkl012mno345pq
MAILGUN_DOMAIN=sandboxe326c1bc9ece48b8ad00df3fb6e8b3e5.mailgun.org
EMAIL_FROM=Sonaura <no-reply@sonaura.in>
```

**Replace:**
- `abc123def456ghi789jkl012mno345pq` with YOUR Private API Key
- `sandboxe326c1bc9ece48b8ad00df3fb6e8b3e5` with YOUR sandbox domain

**Note**: You don't need EMAIL_HOST, EMAIL_PORT, EMAIL_USER, or EMAIL_PASS when using Mailgun API.

**For Local Development (Optional - Uses SMTP):**

If you want to test with SMTP locally, add to `backend/.env`:

```env
# Mailgun SMTP (for local testing only)
EMAIL_HOST=smtp.mailgun.org
EMAIL_PORT=587
EMAIL_USER=postmaster@sandboxe326c1bc9ece48b8ad00df3fb6e8b3e5.mailgun.org
EMAIL_PASS=abc123def456ghi789jkl012mno345pq
EMAIL_FROM=Sonaura <no-reply@sonaura.in>
EMAIL_SECURE=false
```

## ✅ Step 4: Deploy to Render

1. **Add environment variables in Render dashboard** (as shown in Step 3)
2. **Redeploy your backend service** on Render
3. The system will automatically use Mailgun API (not SMTP) when `MAILGUN_API_KEY` and `MAILGUN_DOMAIN` are set

## ✅ Step 5: Test OTP Flow

1. Try signing up or logging in with a test email
2. Check your email inbox for the OTP
3. Check Render logs - you should see:
   ```
   ✅ OTP email sent via Mailgun API to your@email.com (Message ID: ...)
   ```

**Note**: With Mailgun sandbox domain, you can only send emails to **authorized recipients**. To send to any email:
- Add your email in Mailgun dashboard → Domain → Authorized Recipients
- Or upgrade to a verified domain


## 🚀 Production Domain (After Testing)

Once testing is complete with sandbox domain, you can add a real domain:

1. In Mailgun dashboard, click "Add Domain"
2. Add your domain (e.g., `mail.sonaura.in`)
3. Follow DNS verification steps
4. Update Render environment variables with your production domain:

```env
MAILGUN_API_KEY=<your-production-api-key>
MAILGUN_DOMAIN=mail.sonaura.in
EMAIL_FROM=Sonaura <noreply@mail.sonaura.in>
```

## 📧 Verify Emails Are Sending

In Mailgun dashboard:
1. Click on your domain
2. Click "Logs" tab
3. You'll see all sent/failed emails
4. Delivery status and any bounce reasons

## Troubleshooting

| Error | Solution |
|-------|----------|
| `Mailgun API failed: Unauthorized` | Wrong API key, copy Private API Key exactly from Mailgun dashboard |
| `Mailgun API failed: Domain not found` | Check `MAILGUN_DOMAIN` matches your Mailgun domain exactly |
| `ETIMEDOUT` (SMTP) | This is why we use Mailgun API! Make sure `MAILGUN_API_KEY` is set |
| Email not received | Check Mailgun dashboard → Logs, and verify recipient is authorized (for sandbox) |
| `Cannot find sandbox domain` | Make sure you're in correct Mailgun account |

## Costs

- **Sandbox Domain**: 1000 emails/month (FREE)
- **Production Domain**: $35/month gets 50,000 emails/month
- Pay-as-you-go available

## How It Works

The email service automatically detects which method to use:

1. **If `MAILGUN_API_KEY` and `MAILGUN_DOMAIN` are set**: Uses Mailgun HTTP API (works on Render ✅)
2. **Otherwise**: Falls back to SMTP (for local development)

This means:
- **Render/Production**: Set `MAILGUN_API_KEY` and `MAILGUN_DOMAIN` → Uses HTTP API
- **Local Development**: Can use SMTP or Mailgun API (your choice)

## Support

- Mailgun Support: https://www.mailgun.com/support
- For issues, check Mailgun logs for delivery status
