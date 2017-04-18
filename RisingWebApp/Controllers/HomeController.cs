using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace RisingWebApp.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        [AllowAnonymous]
        public ActionResult Index()
        {
            return View();
        }

        [AllowAnonymous]
        public ActionResult Test()
        {
            return View("~/Views/Home/_Home.cshtml");
        }
    }
}
