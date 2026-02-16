package middleware

import (
	"github.com/gin-gonic/gin"
)

func RequestID() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("X-Request-ID", c.GetHeader("X-Request-ID"))
		c.Next()
	}
}
