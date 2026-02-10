# /yo status

Check if Yocore is running and accessible.

## Usage

```
/yo status
```

## Instructions

> **URL/Auth:** `<YOCORE_URL>` = `YOCORE_URL` env var or `http://127.0.0.1:19420`. Never use shell variable expansion — substitute literal values.

1. Call the Yocore health endpoint:
```bash
curl -s --max-time 3 <YOCORE_URL>/health
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
  - Start Yocore
  - Check if YOCORE_URL is set correctly
  - Run: curl -s http://127.0.0.1:19420/health
```
