# ============================================================================
# 03-mssql-python-ornek.py
# ----------------------------------------------------------------------------
# Microsoft'un yeni resmi Python driver'ı (Kasım 2025 GA).
# Kurulum: pip install mssql-python
# Önkoşul: Python 3.10+
# ============================================================================

import mssql_python as ms
import asyncio

# 1) Klasik bağlantı — SQL auth
conn = ms.connect(
    server="sqlnode1.example.com",
    database="demo",
    user="sqladmin",
    password="<your-password>",
    encrypt="strict",          # 2025: TLS 1.3 + TDS 8.0 default
    trust_server_certificate=False
)
cursor = conn.cursor()
cursor.execute("SELECT TOP 5 customer_id, full_name FROM sales.customers")
for row in cursor.fetchall():
    print(row)
conn.close()

# 2) Microsoft Entra ID auth (managed identity)
conn = ms.connect(
    server="sqlnode1.example.com",
    database="demo",
    authentication="ActiveDirectoryManagedIdentity",
    encrypt="strict"
)
cursor = conn.cursor()
cursor.execute("SELECT SUSER_NAME() AS me")
print(cursor.fetchone())
conn.close()

# 3) Async query (yeni driver'da native async)
async def fetch_orders():
    async with ms.connect_async(
        server="sqlnode1.example.com",
        database="demo",
        authentication="ActiveDirectoryDefault"
    ) as conn:
        cursor = await conn.cursor()
        await cursor.execute("""
            SELECT customer_id, COUNT(*) AS orders
            FROM sales.orders
            GROUP BY customer_id
        """)
        rows = await cursor.fetchall()
        return rows

results = asyncio.run(fetch_orders())
for r in results:
    print(r)

# 4) Parametreli sorgu (SQL injection güvenli)
conn = ms.connect(server="sqlnode1.example.com", database="demo", trusted_connection="yes")
cursor = conn.cursor()
search_term = "İstanbul"
cursor.execute(
    "SELECT customer_id, full_name FROM sales.customers WHERE city = ?",
    (search_term,)
)
for row in cursor.fetchall():
    print(row)
conn.close()
