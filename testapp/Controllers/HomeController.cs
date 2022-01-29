using Microsoft.AspNetCore.Mvc;
using System.Text.Encodings.Web;

namespace testapp.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult  Index()
        {
            Console.WriteLine(Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT"));
            ViewData["Environment"] = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");
            return View();
        }
    }
}
