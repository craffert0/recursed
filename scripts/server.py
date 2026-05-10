# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import json
import os.path
import requests
from pathlib import Path


class Server:
    def __init__(self):
        rc = json.loads(Path(os.path.expanduser("~/.recurserc")).read_text())
        self.headers = {"Authorization": "Bearer " + rc["token"]}
        self.session = requests.Session()

    def get(self, path):
        return self.session.get(
            "https://www.recurse.com/api/v1/" + path,
            headers=self.headers,
        )
