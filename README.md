# Serverless Compute Continuous Integration
Deploy a serverless computation with HTTP Trigger

## .Net Core API endpoint that get a SQL Server database
It is mocked using
WeatherForecast API from [First Web App](https://docs.microsoft.com/en-us/aspnet/core/tutorials/first-web-api?view=aspnetcore-5.0&tabs=visual-studio-code)

## Migration from Monolith existing code to autonomous microservice
### Strategy
* Create a CI pipeline for the Monolith code, as is (trying not to impact the code), starting with a develop environment, then iterating on an staging environment
  * If it can't be done, separate a Core-like component, which will be the minimal set of transversal components (it can contains some kind of shared code, like in-house authentication system)
* Identify the _leaves_, code that other components doesn't depends on, and first separate these from the rest of the code
    * It then can be adapt for microservice without impacting other components
    * then iterate to the new leaves
    * each leave became a microservice
* Add/Enhance code coverage and tests
* Move each microservice to an new serverless computation metehode (Azure Function for example)
* Here only the staging environment is setup, the 3 deploy steps can be duplicated for the production environment. Possibly by adding more manual validations if the process requires so.
