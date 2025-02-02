# DevSecOps
Azure DevOps and GitHub for DevSecOps

Steps to create a simple Net 6.0 Project:

Step 1: Set Up Your Environment
Download and install the .NET 6 SDK from the official .NET website.
Download and install Visual Studio Code from the official website.
Search for "C#" and install the official extension provided by Microsoft.

Step 2:
Create a simple Net Application using the terminal with: 
dotnet new mvc -n SimpleNetApp

Add a controller in Controllers folder name it Controller.cs

To build and run:
Cd SimpleNetApp
dotnet build
dotnet run

Step 3:
Back to home folder and create a testing project for unit testing:
cd ..
dotnet new xunit -n SimpleNetApp.Tests

Add the reference into the testing project
cd SimpleNetApp.Tests
dotnet add reference ../SimpleMvcApp/SimpleMvcApp.csproj

Add a Controller for a simple Unit Testing class ControllerTests.cs

To test:
cd SimpleNetApp.Tests
dotnet test


