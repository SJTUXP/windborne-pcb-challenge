from __future__ import annotations

import json
import sys
import urllib.error
import urllib.request
from pathlib import Path

ENDPOINT = "https://windbornesystems.com/career_applications.json"
PAYLOAD_PATH = Path(__file__).with_name("application_payload.json")


def main() -> int:
    if not PAYLOAD_PATH.exists():
        print(
            "application_payload.json was not found. "
            "Copy and edit application_payload_template.json first.",
            file=sys.stderr,
        )
        return 1

    raw = PAYLOAD_PATH.read_text(encoding="utf-8")
    if "YOUR_USERNAME" in raw:
        print("Replace YOUR_USERNAME before submitting.", file=sys.stderr)
        return 1

    payload = json.loads(raw)
    body = json.dumps(payload).encode("utf-8")

    request = urllib.request.Request(
        ENDPOINT,
        data=body,
        method="POST",
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
    )

    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            response_body = response.read().decode("utf-8", errors="replace")
            print(f"Status: {response.status}")
            print("Response:")
            print(response_body)
            return 0 if response.status == 200 else 1
    except urllib.error.HTTPError as exc:
        response_body = exc.read().decode("utf-8", errors="replace")
        print(f"Status: {exc.code}", file=sys.stderr)
        print("Response:", file=sys.stderr)
        print(response_body, file=sys.stderr)
        return 1
    except urllib.error.URLError as exc:
        print(f"Network error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
