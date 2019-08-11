//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package authserv

import (
	"errors"
	"gorani/models"

	"github.com/sunho/webf/servs/dbserv"

	"gorani/utils"
	"net/http"
	"strconv"

	"google.golang.org/api/oauth2/v2"

	"go.uber.org/zap"
)

var (
	ErrNotFound     = errors.New("not found")
	ErrPassMismatch = errors.New("password mismatch")
)

type AuthServ struct {
	DB         *dbserv.DBServ `dim:"on"`
	AdminToken string
	secret     []byte
	oauth      *oauth2.Service
}

type AuthServConfig struct {
	Secret     string `yaml:"secret"`
	AdminToken string `yaml:"admin_token"`
}

func (AuthServConfig) Default() AuthServConfig {
	return AuthServConfig{
		Secret:     "12345678901234",
		AdminToken: "admintoken",
	}
}

func Provide(conf AuthServConfig) (*AuthServ, error) {
	oauth, err := oauth2.New(&http.Client{})
	if err != nil {
		return nil, err
	}
	return &AuthServ{
		AdminToken: conf.AdminToken,
		secret:     []byte(conf.Secret),
		oauth:      oauth,
	}, nil
}

func (AuthServ) ConfigName() string {
	return "auth"
}

func (a *AuthServ) Init() error {
	return nil
}

func (a *AuthServ) getUser(id int) (models.User, error) {
	user := models.User{}
	err := a.DB.Q().Where("id = ?", id).First(&user)
	return user, err
}

func (a *AuthServ) ParseToken(token string) (int, error) {
	str, err := decrypt(a.secret, token)
	if err != nil {
		return 0, err
	}

	return strconv.Atoi(str)
}

func (a *AuthServ) CreateToken(id int) string {
	str, err := encrypt(a.secret, strconv.Itoa(id))
	if err != nil {
		utils.Log.Fatal("Error while creating token", zap.Error(err))
	}
	return str
}

func (a *AuthServ) Login(secert string) (*models.User, string, error) {
	var user models.User
	err := a.DB.Q().Where("secret_code = ?", secert).First(&user)
	if err != nil {
		return nil, "", err
	}
	return &user, a.CreateToken(user.ID), nil
}

func (a *AuthServ) Authorize(token string) (int, error) {
	id, err := a.ParseToken(token)
	if err != nil {
		return 0, err
	}

	return id, nil
}
