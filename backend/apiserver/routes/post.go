//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"fmt"
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/dbserv"

	"github.com/gofrs/uuid"

	"github.com/gobuffalo/nulls"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Post struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (p *Post) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("", p.List)
	d.GET("/sentence-search", p.SentenceSearch)
	d.POST("", p.Post)
	d.RouteFunc("/:postid", func(d *dim.Group) {
		d.DELETE("", p.DeletePost)
		d.RouteFunc("/sentence", func(d *dim.Group) {
			d.POST("/solve", p.SolveSentence)
		})
		d.Route("/rate", &Rate{kind: "post", targetID: func(c *models.Context) int {
			return c.PostParam.ID
		}})
		d.Route("/comment", &PostComment{})
	}, &middles.PostParamMiddle{})
}

func (p *Post) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.DetailedSentencePost
	err := c.Tx.Q().InnerJoin("feed_posts", "feed_posts.post_id = detailed_sentence_posts.id").
		Where("feed_posts.user_id = ?", c.User.ID).
		All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

// TODO
func (p *Post) SentenceSearch(c2 echo.Context) error {
	// c := c2.(*models.Context)
	return nil
}

func (p *Post) Post(c2 echo.Context) error {
	c := c2.(*models.Context)
	var item dbmodels.DetailedSentencePost
	err := c.Bind(&item)
	if err != nil {
		return err
	}
	post, spost := item.Split()
	post.ID = 0
	post.UserID = c.User.ID
	err = c.Tx.Create(&post)
	if err != nil {
		return err
	}
	fmt.Println(post.ID)
	spost.ID = post.ID
	spost.SolvingComment = nulls.Int{}
	spost.SolvingContent = nulls.String{}
	err = c.Tx.Create(&spost)
	if err != nil {
		return err
	}
	id, _ := uuid.NewV4()
	err = c.Tx.Create(&dbmodels.FeedPost{
		ID:     id,
		UserID: c.User.ID,
		PostID: post.ID,
	})
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (p *Post) DeletePost(c2 echo.Context) error {
	c := c2.(*models.Context)
	if c.PostParam.UserID == c.User.ID {
		err := c.Tx.Destroy(c.PostParam)
		if err != nil {
			return err
		}
		return c.NoContent(200)
	}
	return echo.NewHTTPError(403, "Not enough permission")
}

func (p *Post) SolveSentence(c2 echo.Context) error {
	c := c2.(*models.Context)
	spost, err := p.DB.GetSentencePostFromPost(c.Tx, &c.PostParam)
	if err != nil {
		return err
	}
	item := struct {
		CommentID int `json:"comment_id"`
	}{}
	if err = c.Bind(&item); err != nil {
		return err
	}
	var comment dbmodels.PostComment
	err = c.Tx.Where("id = ? AND post_id = ?", item.CommentID, c.PostParam.ID).
		First(&comment)
	if err != nil {
		return err
	}
	spost.SolvingComment = nulls.NewInt(item.CommentID)
	spost.SolvingContent = nulls.NewString(comment.Content)
	err = c.Tx.Update(&spost)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

type PostComment struct {
}

func (p *PostComment) Register(d *dim.Group) {
	d.POST("", p.Post)
	d.GET("", p.List)
	d.RouteFunc("/:commentid", func(d *dim.Group) {
		d.DELETE("", p.Delete)
		d.Route("/rate", &Rate{kind: "post_comment", targetID: func(c *models.Context) int {
			return c.CommentParam.ID
		}})
	}, &middles.PostCommentParamMiddle{})
}

func (p *PostComment) Post(c2 echo.Context) error {
	c := c2.(*models.Context)
	var item dbmodels.PostComment
	if err := c.Bind(&item); err != nil {
		return err
	}
	item.UserID = c.User.ID
	item.PostID = c.PostParam.ID
	err := c.Tx.Create(&item)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (p *PostComment) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.DetailedPostComment
	err := c.Tx.Q().Where("post_id = ?", c.PostParam.ID).
		All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (p *PostComment) Delete(c2 echo.Context) error {
	c := c2.(*models.Context)
	if c.User.ID == c.CommentParam.UserID {
		err := c.Tx.Destroy(&c.CommentParam)
		if err != nil {
			return err
		}
		return c.NoContent(200)
	}
	return echo.NewHTTPError(403, "Not enough permission")
}
