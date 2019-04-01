package dataserv

import (
	"context"
	"encoding/json"
	"gorani/models/datamodels"

	"github.com/segmentio/kafka-go"
)

type DataServ struct {
	userEvWriter *kafka.Writer
}

type DataServConfig struct {
	Host string `yaml:"host"`
}

func Provide(conf DataServConfig) (*DataServ, error) {
	userEvWriter := kafka.NewWriter(kafka.WriterConfig{
		Brokers:  []string{conf.Host},
		Topic:    "user_evlog",
		Balancer: &kafka.LeastBytes{},
	})
	return &DataServ{
		userEvWriter: userEvWriter,
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
	d.userEvWriter.WriteMessages(context.Background(),
		kafka.Message{
			Value: buf,
		},
	)
	return nil
}

func (d *DataServ) AddSystemEventLog(payload datamodels.SystemEventLogPayload) error {
	return nil
}
