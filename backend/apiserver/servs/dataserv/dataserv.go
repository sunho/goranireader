package dataserv

import (
	"context"
	"encoding/json"
	"gorani/models/datamodels"
	"net/http"
	"strconv"
	"time"

	"github.com/segmentio/kafka-go"
)

type DataServ struct {
	userEvWriter *kafka.Writer
	host         string
	client       *http.Client
}

type DataServConfig struct {
	KafkaHost string `yaml:"kafka_host"`
	Host      string `yaml:"host"`
}

func Provide(conf DataServConfig) (*DataServ, error) {
	userEvWriter := kafka.NewWriter(kafka.WriterConfig{
		Brokers:  []string{conf.KafkaHost},
		Topic:    "user_evlog",
		Balancer: &kafka.LeastBytes{},
	})
	return &DataServ{
		userEvWriter: userEvWriter,
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
	go d.userEvWriter.WriteMessages(context.Background(),
		kafka.Message{
			Value: buf,
		},
	)
	return nil
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
