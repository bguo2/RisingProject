using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RisingWebApp.Models
{
    public class RenterApplication
    {
    }

    enum ApplicationStatus
    {
        Applying = 1,
        Withdrawn,
        Pending,
        Declined,
        Approved,
        MovedOut
    }
}