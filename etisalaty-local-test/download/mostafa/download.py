#!/usr/bin/env python3

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from common import download_assigned_contacts, run


if __name__ == "__main__":
    run(lambda: download_assigned_contacts("Mostafa", Path(__file__).with_name("assigned_contacts.csv")))
