package routes

import (
	"gorani/models"
	"gorani/servs/dbserv"

	"github.com/labstack/echo"
)

type Shop struct {
	DB *dbserv.DBServ
}

func (s *Shop) getBooks(c2 echo.Context) error {
	c := c2.(*models.Context)

}

// GET /shop/categories/
// GET /shop/books/
// GET /shop/books/:id/
// POST /shop/books/:id/buy/
// POST /shop/books/:id/reviews/
// POST /shop/books/:id/reviews/:rid/rate/

// GET /books/
// GET /books/:id/payload/
// GET /books/:id/quiz/
// POST /books/:id/quiz/
// PUT /books/:id/progress/

// GET /recommmend/info/
// PUT /recommmend/info/
// GET /recommmend/books/
// POST /recommmend/books/:id/rate/

// GET /uwords/
// POST /uwords/:id/
// GET /uwords/:id/memory/
// POST /uwords/:id/memory/
// POST /uwords/:id/stats/
// DELETE /uwords/:id/

// GET /nwords/
// POST /nwords/
// DELETE /nwords/:id/

// GET /