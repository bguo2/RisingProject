using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web;
using Microsoft.AspNet.Identity.Owin;
using System.Threading.Tasks;
using RisingWebApp.Models;
using RisingWebApp.Managers;

namespace RisingWebApp.Controllers
{

    [Authorize(Roles = "Admin")]
    public class AdminController : ApiController
    {
        private ApplicationUserManager _userManager;
        private readonly IAdminManager _adminManager;
        private readonly string _tempPassword = "Temp@123#!";

        public AdminController(IAdminManager adminManager)
        {
            _adminManager = adminManager;
        }

        public ApplicationUserManager UserManager
        {
            get
            {
                return _userManager ?? HttpContext.Current.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
            private set
            {
                _userManager = value;
            }
        }

        [HttpGet]
        public HttpResponseMessage Get()
        {
            return Request.CreateResponse(HttpStatusCode.OK, "This is test");
        }

        [HttpPut]
        [Route("api/Admin/CreateOwner")]
        public async Task<HttpResponseMessage> CreateOwner([FromBody] OwnerModel model)
        {
            if (model == null || string.IsNullOrEmpty(model.Email) || 
                    (string.IsNullOrEmpty(model.FirstName) && string.IsNullOrEmpty(model.LastName)))
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            //new user
            if(model.Id < 0)
            {
                var user = new ApplicationUser { UserName = model.Email, Email = model.Email };
                var createResult = await UserManager.CreateAsync(user, _tempPassword);
                //no matter whether it is successful or not
                var userId = await _adminManager.CheckUserExistence(model.Email);
                if (userId < 0)
                    return Request.CreateResponse(HttpStatusCode.InternalServerError);
                model.Id = userId;
            }

            var result = await _adminManager.CreateOwner(model);
            if (result)
                return Request.CreateResponse(HttpStatusCode.OK, model);
            return Request.CreateResponse(HttpStatusCode.BadRequest);
        }

        [HttpPut]
        [Route("api/Admin/CreateHouse")]
        public async Task<HttpResponseMessage> CreateHouse(HouseModel model)
        {
            var result = await _adminManager.CreateHouse(model);
            if(result == null)
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }
    }
}
