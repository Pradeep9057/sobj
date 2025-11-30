# Price Update Configuration Guide

## Current Status
- ✅ API Key: Configured (goldapi-13...)
- ✅ Provider: goldapi (GoldAPI.io)
- ❌ Cron: Disabled (`cronEnabled: false`)

## How to Enable Automatic Price Updates

### Option 1: Enable Cron Job (Recommended)
In your `backend/.env` file, set:
```env
DISABLE_PRICE_CRON=false
```
Or simply remove the `DISABLE_PRICE_CRON` variable entirely.

**Then restart your backend server** to activate the cron job.

### Option 2: Manual Refresh (For Testing)
Use the Admin Panel:
1. Go to Admin Panel > Metal Prices tab
2. Click "Refresh Prices Now" button
3. This will fetch latest prices from GoldAPI.io immediately

## Verify Configuration

### Check Status
Visit: `http://localhost:5000/api/prices/status`

Should show:
```json
{
  "ok": true,
  "hasApiKey": true,
  "provider": "goldapi",
  "cronEnabled": true,  // Should be true after enabling
  "latestUpdateFormatted": "11/2/2025, ..."
}
```

### Test API Connection
Visit (as admin): `http://localhost:5000/api/prices/test-api`

Should return:
```json
{
  "ok": true,
  "message": "API connection successful",
  "provider": "goldapi.io",
  "response": {
    "price": 355238.1,
    "pricePerGram": "11421.17"
  }
}
```

## Expected Behavior

### With Cron Enabled:
- Prices update automatically on server startup
- Prices update every hour at minute 0 (e.g., 1:00, 2:00, 3:00, etc.)
- Backend console shows: `✅ Metal prices updated via cron job`

### Without Cron (Current):
- Prices only update when you manually click "Refresh Prices Now" in Admin Panel
- No automatic updates

## Current Prices vs API Prices

Your database has manually changed prices for testing:
- Gold 24K (DB): ₹11,452.84/g
- Gold 24K (API): ₹11,421.17/g ✅ (Correct from GoldAPI.io)

After refreshing, prices will update to match the API values.

## Troubleshooting

1. **Cron not running?**
   - Check `DISABLE_PRICE_CRON` is not set to `'true'`
   - Restart backend server after changing env variables
   - Check backend console for cron job messages

2. **API not updating?**
   - Verify `GOLD_API_KEY` is correct in `.env`
   - Check `GOLD_API_PROVIDER=goldapi` is set
   - Use `/api/prices/test-api` endpoint to verify connection

3. **Prices not reflecting?**
   - Use Admin Panel > Metal Prices > "Refresh Prices Now"
   - Check backend console for error messages
   - Verify database connection is working

