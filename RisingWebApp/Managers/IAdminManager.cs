using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RisingWebApp.Models;

namespace RisingWebApp.Managers
{
    public interface IAdminManager
    {
        Task<bool> CreateOwner(OwnerModel model);
        Task<int> CheckUserExistence(string email);
        Task<HouseModel> CreateHouse(HouseModel model);
    }
}
