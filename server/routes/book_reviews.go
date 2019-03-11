package routes

const reviewsPerPage = 10

type BookReviews struct {
}

func (b *BookReviews) Register(d *dim.Group) {
	d.GET("", b.Get)
	d.POST("", b.Post)
	d.RouteFunc("/:reviewid", func(d *dim.Group){
		d.
	}, &middles.ReviewParamMiddle{})
}

func (b *BooksReviews) Get(c2 echo.Context) error {
	c := c2.(*models.Context)
	p, _ := strconv.Atoi(c.QueryParam("p"))
	var out []dbmodels.Review
	err := c.Tx.Where("book_id = ?", c.BookID).
	Paginate(p, reviesPerPage).
	All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (b *BooksReviews) Post(c2 echo.Context) error {
	c := c2.(*models.Context)
	var review dbmodels.Review
	if err := c.Bind(&review); err != nil {
		return err
	}
	review.ID = 0
	review.UserID = c.User.ID
	reveiw.BookID = c.BookParam.ID
	err =c.Tx.Create(&review)
	if err != nil {
		return err
	}
}

func (b *BooksR)