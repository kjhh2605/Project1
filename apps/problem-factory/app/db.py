from contextlib import contextmanager

import psycopg

from app.core.settings import settings


@contextmanager
def get_conn():
    conn = psycopg.connect(settings.database_url)
    try:
        yield conn
    finally:
        conn.close()
