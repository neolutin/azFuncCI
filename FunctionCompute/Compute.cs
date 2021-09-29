using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace FunctionCompute
{
    public static class Compute
    {
        [Function("ComputeData")]
        public static HttpResponseData Run([HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequestData req,
            FunctionContext executionContext)
        {
            var logger = executionContext.GetLogger("Compute");
            logger.LogInformation("C# HTTP trigger function processed a request.");

            var response = req.CreateResponse(HttpStatusCode.OK);
            var dataApi = GetData(logger);
            dataApi.Wait();
            var data = dataApi.ToString();
            response.WriteString(data ?? "Welcome to Azure Functions!");

            return response;
        }
        
        private static Task GetData(ILogger log)
        {
            var httpClient = new HttpClient();
            var dataApiUrl = Environment.GetEnvironmentVariable("DataApiUrl", EnvironmentVariableTarget.Process);
            
           return httpClient.GetAsync(dataApiUrl).ContinueWith(r =>
               {
                   r.Result.Content.ReadAsStringAsync().ContinueWith(s =>
                   {
                       log.LogInformation(s.Result);
                       return s.Result;
                   });
               }
            );
        }
    }
}
