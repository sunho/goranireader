package encserv

import (
	"golang.org/x/crypto/bcrypt"
)

type EncServ struct {
	key string
}

func Provide() *EncServ {
	return &EncServ{}
}

func (e *EncServ) HashPassword(pass string) (string, error) {
	buf, err := bcrypt.GenerateFromPassword([]byte(pass), bcrypt.DefaultCost)
	return string(buf), err
}

func (e *EncServ) ComparePassword(hash string, pass string) bool {
	return bcrypt.CompareHashAndPassword([]byte(hash), []byte(pass)) == nil
}
