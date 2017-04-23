using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RisingWebApp.Models
{
    public class HouseModel
    {
        public int Id { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostCode { get; set; }
        public int OwnerId { get; set; }
        public decimal CurrentRental { get; set; }
        public decimal ManagementFee { get; set; }
        public bool IsRentedOut { get; set; }
        public string Notes { get; set; }
    }
}