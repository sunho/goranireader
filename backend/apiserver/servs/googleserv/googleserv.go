package googleserv

import (
	"context"
	"gorani/models"

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

func (GoogleServConfig) Default() GoogleServConfig {
	return GoogleServConfig{
		Key:    "your key",
		Secret: "your secret",
	}
}

func (GoogleServ) ConfigName() string {
	return "google"
}

func Provide(conf GoogleServConfig) *GoogleServ {
	return &GoogleServ{
		config: &oauth2.Config{
			ClientID:     conf.Key,
			ClientSecret: conf.Secret,
			Scopes:       []string{"https://www.googleapis.com/auth/books"},
			Endpoint:     google.Endpoint,
		},
	}
}

func (g *GoogleServ) GetClient(user *models.User) (*Client, error) {
	tok, err := user.GetToken()
	if err != nil {
		return nil, err
	}
	hcli := g.config.Client(context.Background(), tok)
	cli, err := books.New(hcli)
	if err != nil {
		return nil, err
	}

	return &Client{
		cli:  cli,
		tok:  tok,
		user: user,
	}, nil
}

func (g *GoogleServ) SetClient(user *models.User, code string) error {
	tok, err := g.config.Exchange(context.TODO(), code)
	if err != nil {
		return err
	}

	err = user.SetToken(tok)
	if err != nil {
		return err
	}

	return nil
}
