// ============================================================================
// 02-retry-policy.cs
// ----------------------------------------------------------------------------
// Microsoft.Data.SqlClient 5.x retry policy (.NET 8+).
// ============================================================================

using Microsoft.Data.SqlClient;
using System.Data;
using Polly;
using Polly.Retry;

public class SqlExecutor
{
    private readonly string _connectionString;

    public SqlExecutor(string connectionString) => _connectionString = connectionString;

    // 1) SqlClient'ın native retry policy (5.x+)
    public async Task<int> ExecuteWithNativeRetryAsync(string sql)
    {
        var retryPolicy = new SqlRetryLogicOption
        {
            NumberOfTries = 5,
            DeltaTime = TimeSpan.FromSeconds(1),
            MaxTimeInterval = TimeSpan.FromSeconds(30),
            TransientErrors = new int[] { 4060, 40197, 40501, 40613, 49918, 49919, 49920 }
        };

        var provider = SqlConfigurableRetryFactory.CreateExponentialRetryProvider(retryPolicy);

        using var conn = new SqlConnection(_connectionString) { RetryLogicProvider = provider };
        await conn.OpenAsync();

        using var cmd = new SqlCommand(sql, conn) { RetryLogicProvider = provider };
        return await cmd.ExecuteNonQueryAsync();
    }

    // 2) Polly ile daha esnek retry + circuit breaker
    public AsyncRetryPolicy GetPollyPolicy() =>
        Policy
            .Handle<SqlException>(IsTransient)
            .WaitAndRetryAsync(
                retryCount: 5,
                sleepDurationProvider: attempt => TimeSpan.FromSeconds(Math.Pow(2, attempt)),
                onRetry: (ex, ts, attempt, ctx) =>
                {
                    Console.WriteLine($"Retry {attempt} after {ts.TotalSeconds}s: {ex.Message}");
                });

    private static bool IsTransient(SqlException ex)
    {
        // Transient SQL error codes
        int[] transient = { 4060, 40197, 40501, 40613, 49918, 49919, 49920, 11001 };
        foreach (SqlError err in ex.Errors)
            if (Array.IndexOf(transient, err.Number) >= 0) return true;
        return false;
    }
}

/* Kullanım:
var executor = new SqlExecutor(connectionString);
var policy = executor.GetPollyPolicy();
await policy.ExecuteAsync(async () => await executor.ExecuteWithNativeRetryAsync("UPDATE ..."));
*/
