using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;
using Dapper;
using RisingWebApp.Models;

namespace RisingWebApp.Managers
{
    public class Repository : IRepository
    {
        private readonly string _connectionString;

        public Repository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<int> CheckUserExistence(string email)
        {
            using (IDbConnection connection = new MySqlConnection(_connectionString))
            {
                connection.Open();
                var result = await connection.QueryAsync<int>("sp_check_user_exist", new { _Email = email}, commandType: CommandType.StoredProcedure);
                return result.FirstOrDefault();
            }
        }

        public async Task<OwnerModel> CreateOwner(OwnerModel model)
        {
            using (IDbConnection connection = new MySqlConnection(_connectionString))
            {
                connection.Open();
                var p = new DynamicParameters();
                p.Add("@_Id", model.Id);
                p.Add("@_FirstName", model.FirstName);
                p.Add("@_LastName", model.LastName);
                p.Add("@_Address", model.Address);
                p.Add("@_City", model.City);
                p.Add("@_State", model.State);
                p.Add("@_PostCode", model.PostCode);
                p.Add("@_BankName", model.BankName);
                p.Add("@_BankRoutingNumber", model.BankRoutingNumber);
                p.Add("@_BankAccount", model.BankAccount);
                p.Add("@_Phone", model.Phone);
                var result = await connection.ExecuteAsync("sp_create_owner", p, commandType: CommandType.StoredProcedure);
                if (result != 1)
                    return null;
            }

            return model;
        }
    }
}