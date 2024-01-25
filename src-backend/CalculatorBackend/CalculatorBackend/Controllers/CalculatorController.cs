using Microsoft.ApplicationInsights;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace CalculatorBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CalculatorController : ControllerBase
    {
        TelemetryClient telemetryClient = new();

        ILogger<HomeController> _logger;

        public CalculatorController(ILogger<HomeController> logger) 
        {
            _logger = logger;
        }


        // GET: api/<CalculatorController>
        [HttpGet]
        public IActionResult Get(int number1, int number2)
        {
            telemetryClient.TrackEvent($"Processing Calculator API: {number1} & {number2}");
            _logger.LogCritical($"Processing Calculator API: {number1} & {number2}");





            int result = number1 / (number2 - 1);

            return Ok(
                "{\"formula\": \"<formula>\" \"result\": <result> }"
                    .Replace("<result>", (result).ToString())
                    .Replace("<formula>", $"{number1} / {number2}")
                );
        }
    }
}
