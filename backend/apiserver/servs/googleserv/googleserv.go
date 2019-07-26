package googleserv

import (
	"context"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	books "google.golang.org/api/books/v1"
)

type GoogleServ struct {
	config *oauth2.Config
}

type GoogleServConfig struct {
	Key    string
	Secret string
}

func (GoogleServ) ConfigName() string {
	return "google"
}

func Provide(conf GoogleServConfig) *GoogleServ {
	return &GoogleServ{
		config: &oauth2.Config{
			ClientID:     conf.Key,
			ClientSecret: conf.Secret,
			Scopes:       []string{"https://www.googleapis.com/auth/userinfo.email"},
			Endpoint:     google.Endpoint,
		},
	}
}

func (g *GoogleServ) GetClient(code string) (*Client, error) {
	tok, err := g.config.Exchange(context.TODO(), code)
	if err != nil {
		return nil, err
	}
	hcli := g.config.Client(context.Background(), tok)
	cli, err := books.New(hcli)
	if err != nil {
		return nil, err
	}

	return &Client{
		cli: cli,
	}, nil
}
