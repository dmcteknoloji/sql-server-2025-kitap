// ============================================================================
// 03-dapper-mikrolib.cs
// ----------------------------------------------------------------------------
// Dapper: minimal mapping, hızlı, kontrol bende. EF Core'a alternatif.
// dotnet add package Dapper
// dotnet add package Microsoft.Data.SqlClient
// ============================================================================

using Dapper;
using Microsoft.Data.SqlClient;

public record CustomerSummary(int CustomerId, string FullName, int OrderCount, decimal TotalSpent);

public class CustomerRepository
{
    private readonly string _connectionString;

    public CustomerRepository(string connectionString) => _connectionString = connectionString;

    public async Task<IEnumerable<CustomerSummary>> GetTopCustomersAsync(int top = 10)
    {
        using var conn = new SqlConnection(_connectionString);

        const string sql = @"
            SELECT TOP (@TopN)
                c.customer_id AS CustomerId,
                c.full_name AS FullName,
                COUNT(o.order_id) AS OrderCount,
                ISNULL(SUM(o.total_amount), 0) AS TotalSpent
            FROM sales.customers c
            LEFT JOIN sales.orders o ON o.customer_id = c.customer_id
            GROUP BY c.customer_id, c.full_name
            ORDER BY TotalSpent DESC;
        ";

        return await conn.QueryAsync<CustomerSummary>(sql, new { TopN = top });
    }

    public async Task<int> InsertOrderAsync(int customerId, decimal totalAmount)
    {
        using var conn = new SqlConnection(_connectionString);

        const string sql = @"
            INSERT INTO sales.orders (customer_id, total_amount, status)
            OUTPUT INSERTED.order_id
            VALUES (@CustomerId, @TotalAmount, 'pending');
        ";

        return await conn.ExecuteScalarAsync<int>(sql, new { CustomerId = customerId, TotalAmount = totalAmount });
    }

    // Stored procedure çağrısı
    public async Task<dynamic?> CreateOrderViaSpAsync(int customerId, decimal total)
    {
        using var conn = new SqlConnection(_connectionString);
        return await conn.QueryFirstOrDefaultAsync<dynamic>(
            "sales.usp_create_order",
            new { customer_id = customerId, total = total },
            commandType: System.Data.CommandType.StoredProcedure
        );
    }
}
