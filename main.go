package main

import (
	"log"
	"net/http"

	"github.com/spf13/viper"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	viper.AutomaticEnv()

	viper.SetDefault("PORT", ":1323")

	e := echo.New()

	e.Pre(
		middleware.RemoveTrailingSlash(),
	)

	e.Use(
		middleware.Recover(),
		middleware.Logger(),
	)

	e.Any("/*", func(c echo.Context) error {
		return c.JSON(http.StatusOK, echo.Map{
			"message": "hello",
		})
	})

	log.Fatal(e.Start(viper.GetString("PORT")))
}
