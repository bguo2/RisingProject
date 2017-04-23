using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Threading.Tasks;
using RisingWebApp.Models;

namespace RisingWebApp.Managers
{
    public class AdminManager : IAdminManager
    {
        private readonly IRepository _repository;

        public AdminManager(IRepository repository)
        {
            _repository = repository;
        }

        public async Task<int> CheckUserExistence(string email)
        {
            if (string.IsNullOrEmpty(email))
                return -1;
            return await _repository.CheckUserExistence(email);
        }

        public async Task<bool> CreateOwner(OwnerModel model)
        {
            if (string.IsNullOrEmpty(model.Email))
                return false;
            var result = _repository.CreateOwner(model);
            return (result != null);
        }
    }
}