package googleserv

import (
	"strconv"

	books "google.golang.org/api/books/v1"
)

type Client struct {
	cli *books.Service
}

func (g *Client) GetBookIDs() ([]string, error) {
	bs, err := g.cli.Mylibrary.Bookshelves.List().Do()
	if err != nil {
		return nil, err
	}
	ids := make(map[string]bool)
	for _, b := range bs.Items {
		vol, err := g.cli.Mylibrary.Bookshelves.Volumes.List(strconv.FormatInt(b.Id, 10)).Do()
		if err != nil {
			return nil, err
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
