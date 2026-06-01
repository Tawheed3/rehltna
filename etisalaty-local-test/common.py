#!/usr/bin/env python3

import csv
import json
import os
import sys
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen


ROOT = Path(__file__).resolve().parent
PROJECT_ROOT = ROOT.parent
DEFAULT_BASE_URL = "http://127.0.0.1:8000/api/v1/etisalaty"
EMPLOYEE_DEFAULTS = {
    "ZAKARIA": {"email": "zakaria@rehltna.com", "password": "123456"},
    "MOSTAFA": {"email": "mostafa@rehltna.com", "password": "123456"},
    "KAMAL": {"email": "kamal@rehltna.com", "password": "123456"},
}


def load_project_env() -> dict[str, str]:
    values: dict[str, str] = {}
    env_file = PROJECT_ROOT / ".env"

    if not env_file.exists():
        return values

    for line in env_file.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue

        key, value = line.split("=", 1)
        values[key.strip()] = value.strip().strip("\"'")

    return values


PROJECT_ENV = load_project_env()


def required_env(name: str) -> str:
    value = os.getenv(name)
    if value:
        return value

    raise RuntimeError(f"Missing required environment variable: {name}")


def setting(name: str, default: str | None = None) -> str:
    value = os.getenv(name) or PROJECT_ENV.get(name) or default
    if value:
        return value

    raise RuntimeError(f"Missing required setting: {name}")


def api_request(method: str, path: str, token: str | None = None, payload: dict | None = None) -> dict:
    base_url = setting("ETISALATY_BASE_URL", DEFAULT_BASE_URL).rstrip("/")
    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-API-KEY": setting("ETISALATY_API_KEY", PROJECT_ENV.get("API_KEY")),
        "X-Tenant-ID": setting("ETISALATY_TENANT_ID", "1"),
    }

    if token:
        headers["Authorization"] = f"Bearer {token}"

    body = json.dumps(payload).encode("utf-8") if payload is not None else None
    request = Request(f"{base_url}/{path.lstrip('/')}", data=body, headers=headers, method=method)

    try:
        with urlopen(request, timeout=20) as response:
            return json.loads(response.read().decode("utf-8"))
    except HTTPError as error:
        response_body = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"API returned HTTP {error.code}: {response_body}") from error
    except URLError as error:
        raise RuntimeError(f"Cannot reach local API server: {error.reason}") from error


def login(email: str, password: str) -> str:
    response = api_request("POST", "login", payload={"email": email, "password": password})
    return response["data"]["access_token"]


def upload_dummy_contacts(employee: str, contacts: list[dict[str, str]]) -> None:
    prefix = employee.upper()
    defaults = EMPLOYEE_DEFAULTS[prefix]
    token = login(
        os.getenv(f"ETISALATY_{prefix}_EMAIL", defaults["email"]),
        os.getenv(f"ETISALATY_{prefix}_PASSWORD", defaults["password"]),
    )
    response = api_request("POST", "upload-contacts", token=token, payload={"contacts": contacts})
    print(json.dumps(response, indent=2, ensure_ascii=False))


def security_token(employee_name: str) -> str:
    employee_defaults = EMPLOYEE_DEFAULTS[employee_name.upper()]

    return login(
        os.getenv("ETISALATY_SECURITY_EMAIL", employee_defaults["email"]),
        os.getenv("ETISALATY_SECURITY_PASSWORD", employee_defaults["password"]),
    )


def resolve_employee_id(summary: dict, employee_name: str) -> int:
    employees = summary["data"]["summary"]["assigned_per_employee"]
    exact_matches = [
        employee for employee in employees
        if employee["employee_name"].strip().casefold() == employee_name.casefold()
    ]
    matches = exact_matches or [
        employee for employee in employees
        if employee["employee_name"].strip().casefold().startswith(employee_name.casefold())
    ]

    if len(matches) != 1:
        available = ", ".join(employee["employee_name"] for employee in employees)
        raise RuntimeError(f"Could not resolve one '{employee_name}' employee. Available users: {available}")

    return matches[0]["employee_id"]


def download_assigned_contacts(employee_name: str, destination: Path) -> None:
    token = security_token(employee_name)
    summary = api_request("GET", "distribution-summary", token=token)
    employee_id = resolve_employee_id(summary, employee_name)
    response = api_request("GET", f"download-assigned-contacts/{employee_id}", token=token)
    contacts = response["data"]["contacts"]

    destination.parent.mkdir(parents=True, exist_ok=True)
    with destination.open("w", newline="", encoding="utf-8") as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=["phone_number", "contact_name", "ownership_marker"])
        writer.writeheader()
        writer.writerows(contacts)

    print(json.dumps(summary, indent=2, ensure_ascii=False))
    print(f"Downloaded {len(contacts)} contacts to {destination}")


def run(action) -> None:
    try:
        action()
    except (KeyError, RuntimeError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        raise SystemExit(1) from error
