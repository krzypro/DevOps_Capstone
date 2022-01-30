namespace TestApp.Controllers;

using Microsoft.AspNetCore.Mvc;

public class HomeController : Controller
{
    public IActionResult Index()
    {
        Console.WriteLine(Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT"));
        this.ViewData["Environment"] = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");
        return this.View();
    }
}
