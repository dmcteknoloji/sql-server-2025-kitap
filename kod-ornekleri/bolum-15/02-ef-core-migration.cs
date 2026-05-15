// ============================================================================
// 02-ef-core-migration.cs
// ----------------------------------------------------------------------------
// EF Core code-first migration örneği. Komutlar:
//   dotnet ef migrations add InitialCreate
//   dotnet ef database update
// ============================================================================

using Microsoft.EntityFrameworkCore.Migrations;

public partial class AddDocumentChunks : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.EnsureSchema(name: "ai");

        migrationBuilder.CreateTable(
            name: "document_chunks",
            schema: "ai",
            columns: table => new
            {
                ChunkId = table.Column<long>(name: "chunk_id", type: "bigint", nullable: false)
                    .Annotation("SqlServer:Identity", "1, 1"),
                SourceDoc = table.Column<string>(name: "source_doc", type: "nvarchar(200)", nullable: false),
                ChunkIndex = table.Column<int>(name: "chunk_index", type: "int", nullable: false),
                Content = table.Column<string>(type: "nvarchar(max)", nullable: false),
                Embedding = table.Column<float[]>(type: "VECTOR(1536)", nullable: true),
                CreatedAt = table.Column<DateTime>(name: "created_at", type: "datetime2(0)",
                    nullable: false, defaultValueSql: "SYSUTCDATETIME()")
            },
            constraints: table => table.PrimaryKey("PK_document_chunks", x => x.ChunkId));

        // Raw SQL: vector index (EF Core builder yet not aware)
        migrationBuilder.Sql(@"
            CREATE VECTOR INDEX vi_document_chunks_embedding
            ON ai.document_chunks (embedding)
            WITH (METRIC = 'cosine', TYPE = 'diskann');
        ");
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.Sql("DROP INDEX vi_document_chunks_embedding ON ai.document_chunks;");
        migrationBuilder.DropTable(name: "document_chunks", schema: "ai");
    }
}
