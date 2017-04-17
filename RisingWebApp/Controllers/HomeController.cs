using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace RisingWebApp.Controllers
{
    public class HomeController : Controller
    {
        [AllowAnonymous]
        public ActionResult Index()
        {
            return View();
        }
    }
}
