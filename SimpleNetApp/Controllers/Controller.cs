using Microsoft.AspNetCore.Mvc;

namespace SimpleNetApp.Controllers
{
    public class HelloController : Controller
    {
        public IActionResult Index()
        {
            return Content("Hello, World!");
        }
    }
}
