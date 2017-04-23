using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RisingWebApp.Models;

namespace RisingWebApp.Managers
{
    public interface IRepository
    {
        Task<int> CheckUserExistence(string email);
        Task<OwnerModel> CreateOwner(OwnerModel model);
    }
}
