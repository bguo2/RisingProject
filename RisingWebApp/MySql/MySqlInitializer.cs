using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using RisingWebApp.Models;
using System.Configuration;
using System.Data.SqlClient;

namespace RisingWebApp.MySql
{
    public class MySqlInitializer : IDatabaseInitializer<ApplicationDbContext>
    {
        public void InitializeDatabase(ApplicationDbContext context)
        {
            if (!context.Database.Exists())
            {
                // if database did not exist before - create it
                context.Database.Create();
            }
            else
            {
                var connectionStr = ConfigurationManager.ConnectionStrings[ApplicationDbContext.MySQLConnStringName].ConnectionString;
                var builder = new SqlConnectionStringBuilder(connectionStr);
                var query = string.Format("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '{0}' AND table_name =   '__MigrationHistory'", builder["Database"]);

                // query to check if MigrationHistory table is present in the database 
                var migrationHistoryTableExists = ((IObjectContextAdapter)context).ObjectContext.ExecuteStoreQuery<int>(query);

                // if MigrationHistory table is not there (which is the case first time we run) - create it
                if (migrationHistoryTableExists.FirstOrDefault() == 0)
                {
                    context.Database.Delete();
                    context.Database.Create();
                }
            }
        }
    }
}