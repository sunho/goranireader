package googleserv

import (
	"gorani/models"
	"log"
	"strconv"

	"golang.org/x/oauth2"

	books "google.golang.org/api/books/v1"
)

type Client struct {
	cli  *books.Service
	tok  *oauth2.Token
	user *models.User
}

func (g *Client) GetBookIDs() ([]string, error) {
	bs, err := g.cli.Mylibrary.Bookshelves.List().Do()
	if err != nil {
		return nil, err
	}
	ids := make(map[string]bool)
	for _, b := range bs.Items {
		if b.Title == "Browsing history" {
			continue
		}
		vol, err := g.cli.Mylibrary.Bookshelves.Volumes.List(strconv.FormatInt(b.Id, 10)).Do()
		if err != nil {
			log.Printf("Error in %v %v", b.VolumeCount, err)
		}
		for _, v := range vol.Items {
			ids[v.Id] = true
		}
	}
	out := make([]string, 0, len(ids))
	for id := range ids {
		out = append(out, id)
	}
	return out, nil
}

func (g *Client) Clean() error {
	err := g.user.SetToken(g.tok)
	if err != nil {
		return err
	}

	return nil
}
