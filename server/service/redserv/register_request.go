package redserv

import (
	"encoding/json"
	"errors"
	"gorani/models"

	"github.com/gofrs/uuid"
)

const (
	regReqsKey = "regReqs"
)

func (s *RedServ) CreateRegRequest(req models.RegRequest) (string, error) {
	k, err := uuid.NewV4()
	if err != nil {
		return "", err
	}
	key := k.String()

	buf, err := json.Marshal(req)
	if err != nil {
		return "", err
	}

	if err = s.cli.HSet(regReqsKey, key, buf).Err(); err != nil {
		return "", err
	}

	return key, nil
}

func (s *RedServ) GetRegRequest(key string) (models.RegRequest, error) {
	exists, err := s.cli.HExists(regReqsKey, key).Result()
	if err != nil {
		return models.RegRequest{}, err
	}
	if !exists {
		return models.RegRequest{}, errors.New("no such reigster request")
	}

	buf, err := s.cli.HGet(regReqsKey, key).Result()
	if err != nil {
		return models.RegRequest{}, err
	}

	out := models.RegRequest{}
	err = json.Unmarshal([]byte(buf), &out)
	if err != nil {
		return models.RegRequest{}, err
	}

	return out, nil
}

func (s *RedServ) DeleteRegisterRequest(key string) error {
	return s.cli.HDel(regReqsKey, key).Err()
}
