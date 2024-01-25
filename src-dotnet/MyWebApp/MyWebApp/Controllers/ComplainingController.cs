using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace MyWebApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ComplainingController : ControllerBase
    {
        Random rand = new Random();

        // GET: api/<ComplainingController>
        [HttpGet]
        public async Task<string> Get()
        {
            int delayInSeconds = rand.Next(1, 5);
            await Task.Delay(delayInSeconds * 1000);
            
            if(delayInSeconds > 3)
            {
                throw new Exception("Sorry, I'm too lazy today");
            }

            return "Done!";
        }
    }
}
