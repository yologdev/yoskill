# /yo status

Check if Yocore is running and accessible.

## Usage

```
/yo status
```

## Instructions

1. Call the Yocore health endpoint:
```bash
curl -s --max-time 3 "${YOCORE_URL:-http://127.0.0.1:19420}/health"
```

2. If reachable, display:
```
Yocore Status: Connected
  URL: <YOCORE_URL>
  Version: <version from response>
```

3. If unreachable, display:
```
Yocore Status: Not reachable
  URL: <YOCORE_URL>

Troubleshooting:
  - Start the Yolog desktop app (it launches Yocore automatically)
  - Check if YOCORE_URL is set correctly
  - Run: curl -s http://127.0.0.1:19420/health
```
