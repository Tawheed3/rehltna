#!/usr/bin/env python3

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from common import run, upload_dummy_contacts


def contacts(start: int, end: int, label: str) -> list[dict[str, str]]:
    return [
        {"phone_number": f"05{number:08d}", "contact_name": f"{label} {number - start + 1}"}
        for number in range(start, end + 1)
    ]


CONTACTS = (
    contacts(25, 36, "Kamal Exclusive")
    + contacts(101, 106, "Zakaria Kamal Shared")
    + contacts(401, 406, "Mostafa Kamal Shared")
    + contacts(301, 306, "All Employees Shared")
)


if __name__ == "__main__":
    run(lambda: upload_dummy_contacts("kamal", CONTACTS))
