package redserv

import (
	"errors"

	"github.com/gofrs/uuid"
)

const (
	regReqsKey = "regReqs"
)

func (s *RedServ) CreateRegisterRequest(email string) (string, error) {
	k, err := uuid.NewV4()
	if err != nil {
		return "", err
	}
	key := k.String()

	if err = s.cli.HSet(regReqsKey, key, email).Err(); err != nil {
		return "", err
	}

	return key, nil
}

func (s *RedServ) GetRegisterRequest(key string) (string, error) {
	exists, err := s.cli.HExists(regReqsKey, key).Result()
	if err != nil {
		return "", err
	}
	if !exists {
		return "", errors.New("no such reigster request")
	}

	email, err := s.cli.HGet(regReqsKey, key).Result()
	if err != nil {
		return "", err
	}

	return email, nil
}

func (s *RedServ) DeleteRegisterRequest(key string) error {
	return s.cli.HDel(regReqsKey, key).Err()
}
