# Etisalaty Local API Test Harness

This folder replaces the Flutter app during local testing. It uses only Python's
standard library.

## Folder Layout

```text
upload/kamal/upload.py
upload/zakaria/upload.py
upload/mostafa/upload.py
download/kamal/download.py
download/zakaria/download.py
download/mostafa/download.py
```

Each upload script sends 30 dummy Saudi numbers: 12 exclusive numbers, 6 shared
with each of the other employees, and 6 shared by all three employees. The
distribution summary therefore contains `Z`, `M`, `K`, `ZM`, `ZK`, `MK`, and
`ZMK` groups.

## Configuration

Start the Laravel server:

```bash
php artisan serve
```

The upload scripts default to these local employee credentials:

```bash
zakaria@rehltna.com / 123456
mostafa@rehltna.com / 123456
kamal@rehltna.com / 123456
```

`API_KEY` is loaded automatically from the project `.env`. Override it with
`ETISALATY_API_KEY` when needed. The default server URL is
`http://127.0.0.1:8000/api/v1/etisalaty`; override it with
`ETISALATY_BASE_URL`.

The default tenant ID is `1`. Override it with `ETISALATY_TENANT_ID` when
needed. Download scripts default to the matching employee credentials. In an
environment with a dedicated security-role account, override them with:

```bash
export ETISALATY_SECURITY_EMAIL='security@example.com'
export ETISALATY_SECURITY_PASSWORD='password'
```

## Run Upload Tests

```bash
python3 etisalaty-local-test/upload/zakaria/upload.py
python3 etisalaty-local-test/upload/mostafa/upload.py
python3 etisalaty-local-test/upload/kamal/upload.py
```

## Run Download Tests

Each script downloads the final assigned list for one employee and writes a CSV
file in its own folder:

```bash
python3 etisalaty-local-test/download/zakaria/download.py
python3 etisalaty-local-test/download/mostafa/download.py
python3 etisalaty-local-test/download/kamal/download.py
```
