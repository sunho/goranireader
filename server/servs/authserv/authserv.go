package authserv

import (
	"gorani/models/dbmodels"
	"golang.org/x/crypto/bcrypt"
	"errors"
	"gorani/servs/dbserv"
	"gorani/utils"
	"strconv"

	"go.uber.org/zap"
)

var (
	ErrNotFound = errors.New("not found")
	ErrPassMismatch = errors.New("password mismatch")
)

type AuthServ struct {
	DB     *dbserv.DBServ       `dim:"on"`
	AdminToken string
	secret []byte
}

type AuthServConf struct {
	Secret string `yaml:"secret"`
	AdminToken string  `yaml:"admin_token"`
}

func Provide(conf AuthServConf) *AuthServ {
	return &AuthServ{
		AdminToken: conf.AdminToken,
		secret: []byte(conf.Secret),
	}
}

func (AuthServ) ConfigName() string {
	return "auth"
}

func (a *AuthServ) Init() error {
	return nil
}

func (a *AuthServ) GetUser(id int) (dbmodels.User, error) {
	user := dbmodels.User{}
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

func (a *AuthServ) Login(username string, password string) (string, error) {
	var user dbmodels.User
	err := a.DB.Q().Where("username = ?", user).First(&user)
	if err != nil {
		return "", err
	}

	if a.ComparePassword(user.PasswordHash, password) {
		return a.CreateToken(user.ID), nil
	}

	return "", ErrPassMismatch
}

func (a *AuthServ) Authorize(token string) (dbmodels.User, error) {
	id, err := a.ParseToken(token)
	if err != nil {
		return dbmodels.User{}, err
	}

	return a.GetUser(id)
}

func (a *AuthServ) HashPassword(password string) (string, error) {
	buf, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	return string(buf), err
}

func (e *AuthServ) ComparePassword(hash string, password string) bool {
	return bcrypt.CompareHashAndPassword([]byte(hash), []byte(password)) == nil
}