using Microsoft.ApplicationInsights;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging.ApplicationInsights;
using MyWebApp.Models;
using System.Diagnostics;

namespace MyWebApp.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private TelemetryClient telemetry = new TelemetryClient();

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            return View();
        }

        public async Task<IActionResult> InitiateDivisions()
        {
            List<string> calculations = new();
            HttpClient client = new();

            for (int callsCounter = 10; callsCounter > 0; callsCounter--)
            {
                try
                {
                    telemetry.TrackEvent($"Executing call #{callsCounter}");
                    calculations.Add(await client.GetStringAsync($"https://crgar-webapp-backend.azurewebsites.net/api/calculator?number1=78&number2={callsCounter}"));
                }
                catch(Exception ex)
                {
                    telemetry.TrackException(ex);
                    calculations.Add("There was an error in this one :(!");
                }
            }

            ViewData["calculations"] = calculations;
            return View();

        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
