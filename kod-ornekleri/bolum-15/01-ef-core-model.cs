// ============================================================================
// 01-ef-core-model.cs
// ----------------------------------------------------------------------------
// EF Core 9 + Microsoft.EntityFrameworkCore.SqlServer + VECTOR search plugin.
// dotnet add package Microsoft.EntityFrameworkCore.SqlServer
// dotnet add package EFCore.SqlServer.VectorSearch
// ============================================================================

using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.SqlServer.VectorSearch;

public class Customer
{
    public int CustomerId { get; set; }
    public string FullName { get; set; } = "";
    public string Email { get; set; } = "";
    public string? Phone { get; set; }
    public string? City { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<Order> Orders { get; set; } = new();
}

public class Order
{
    public long OrderId { get; set; }
    public int CustomerId { get; set; }
    public DateTime OrderDate { get; set; }
    public string Status { get; set; } = "pending";
    public decimal TotalAmount { get; set; }
    public Customer Customer { get; set; } = null!;
}

public class DocumentChunk
{
    public long ChunkId { get; set; }
    public string SourceDoc { get; set; } = "";
    public int ChunkIndex { get; set; }
    public string Content { get; set; } = "";
    // EF Core vector search plugin ile VECTOR(1536) kolonu
    public float[]? Embedding { get; set; }
}

public class DemoDbContext : DbContext
{
    public DbSet<Customer> Customers => Set<Customer>();
    public DbSet<Order> Orders => Set<Order>();
    public DbSet<DocumentChunk> DocumentChunks => Set<DocumentChunk>();

    protected override void OnConfiguring(DbContextOptionsBuilder options)
    {
        options.UseSqlServer(
            connectionString: "Server=sqlnode.example.com;Database=demo;Authentication=Active Directory Default;Encrypt=Strict;",
            sql => sql.UseVectorSearch()    // vector tipini ve VECTOR_SEARCH'ü etkinleştir
        );
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Customer>(b =>
        {
            b.ToTable("customers", schema: "sales");
            b.HasKey(c => c.CustomerId);
            b.Property(c => c.Email).HasMaxLength(254).IsRequired();
            b.HasIndex(c => c.Email).IsUnique();
        });

        modelBuilder.Entity<Order>(b =>
        {
            b.ToTable("orders", schema: "sales");
            b.HasKey(o => o.OrderId);
            b.HasOne(o => o.Customer).WithMany(c => c.Orders).HasForeignKey(o => o.CustomerId);
        });

        modelBuilder.Entity<DocumentChunk>(b =>
        {
            b.ToTable("document_chunks", schema: "ai");
            b.HasKey(d => d.ChunkId);
            b.Property(d => d.Embedding).HasColumnType("VECTOR(1536)");
        });
    }
}

// Vector search örneği
public class SearchService
{
    private readonly DemoDbContext _ctx;
    public SearchService(DemoDbContext ctx) => _ctx = ctx;

    public async Task<List<DocumentChunk>> SearchAsync(float[] queryEmbedding, int topN = 10)
    {
        return await _ctx.DocumentChunks
            .OrderBy(d => EF.Functions.VectorDistance("cosine", d.Embedding!, queryEmbedding))
            .Take(topN)
            .ToListAsync();
    }
}
