using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Owin;
using Owin;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using RisingWebApp.Models;

[assembly: OwinStartup(typeof(RisingWebApp.Startup))]

namespace RisingWebApp
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
            createRolesandUsers();
        }

        // In this method we will create default User roles and Admin user for login   
        private void createRolesandUsers()
        {
            ApplicationDbContext context = new ApplicationDbContext();

            var roleManager = new RoleManager<CustomRole, int>(new CustomRoleStore(context));
            var UserManager = new UserManager<ApplicationUser, int>(new CustomUserStore(context));

            // In Startup iam creating first Admin Role and creating a default Admin User    
            if (!roleManager.RoleExists(UserRoles.Admin))
            {
                // first we create Admin rool   
                var role = new CustomRole(UserRoles.Admin);
                roleManager.Create(role);
            }

            if (!roleManager.RoleExists(UserRoles.Owner))
            {
                var role = new CustomRole(UserRoles.Owner); ;
                roleManager.Create(role);
            }

            if (!roleManager.RoleExists(UserRoles.Applicant))
            {
                var role = new CustomRole(UserRoles.Applicant); ;
                roleManager.Create(role);
            }
        }
    }
}
