using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RisingWebApp.Models
{
    public class OwnerModel : UserModel
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostCode { get; set; }
        public string BankName { get; set; }
        public string BankRoutingNumber { get; set; }
        public string BankAccount { get; set; }
        public string Phone { get; set; }
    }
}