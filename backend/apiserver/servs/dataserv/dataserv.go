//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package dataserv

import (
	"github.com/go-redis/redis"
	"encoding/json"
	"gorani/models/datamodels"
	"net/http"
	"strconv"
	"time"

)

type DataServ struct {
	writer *redis.Client
	host         string
	client       *http.Client
}

type DataServConfig struct {
	RedisHost string `yaml:"redis_host"`
	Host      string `yaml:"host"`
}

func Provide(conf DataServConfig) (*DataServ, error) {
	client := redis.NewClient(&redis.Options{
		Addr:     conf.RedisHost,
		Password: "", // no password set
		DB:       0,  // use default DB
	})
	return &DataServ{
		writer:  client,
		host:         conf.Host,
		client: &http.Client{
			Timeout: 5 * time.Second,
		},
	}, nil
}

func (DataServ) ConfigName() string {
	return "data"
}

func (d *DataServ) AddUserEventLogPayload(userid int, payload datamodels.UserEventLogPayload) error {
	evlog := datamodels.NewUserEventLog(userid, payload)
	return d.AddUserEventLog(evlog)
}

func (d *DataServ) AddUserEventLog(evlog *datamodels.UserEventLog) error {
	buf, err := json.Marshal(evlog)
	if err != nil {
		return err
	}
	return d.writer.XAdd(&redis.XAddArgs{
		Stream: "user_evlog",
		MaxLen: 100,
		MaxLenApprox: 100,
		Values: map[string]interface{}{
			"topic": "user_evlog",
			"value": buf,
		},
	}).Err()
}

func (d *DataServ) GetSimilarWords(userid int, word string) ([]datamodels.SimilarWord, error) {
	req, err := http.NewRequest("GET", d.host+"/word/similar", nil)
	if err != nil {
		return nil, err
	}

	q := req.URL.Query()
	q.Add("user_id", strconv.Itoa(userid))
	q.Add("word", word)
	req.URL.RawQuery = q.Encode()

	resp, err := d.client.Do(req)
	if err != nil {
		return nil, err
	}

	var out []datamodels.SimilarWord
	err = json.NewDecoder(resp.Body).Decode(&out)
	if err != nil {
		return nil, err
	}

	return out, nil
}

func (d *DataServ) AddSystemEventLog(payload datamodels.SystemEventLogPayload) error {
	return nil
}
