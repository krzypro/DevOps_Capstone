namespace TestApp.Controllers;

using Microsoft.AspNetCore.Mvc;

public class HomeController : Controller
{
    public IActionResult Index()
    {
        this.ViewData["Build"] = Environment.GetEnvironmentVariable("CAPSTONE_BUILD");
        this.ViewData["Deploy"] = Environment.GetEnvironmentVariable("CAPSTONE_DEPLOY");
        return this.View();
    }
}
