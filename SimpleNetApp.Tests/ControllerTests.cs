using Xunit;
using SimpleNetApp.Controllers;
using Microsoft.AspNetCore.Mvc;

namespace SimpleNetApp.Tests
{
    public class ControllerTests
    {
        [Fact]
        public void Index_ReturnsContentResult_WithHelloWorldMessage()
        {
            // Arrange
            var controller = new HelloController();

            // Act
            var result = controller.Index();

            // Assert
            var contentResult = Assert.IsType<ContentResult>(result);
            Assert.Equal("Hello, World!", contentResult.Content);
        }
    }
}