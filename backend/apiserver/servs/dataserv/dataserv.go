//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package dataserv

import (
	"gorani/models/datamodels"
)

type DataServ struct {
	host string
}

type DataServConfig struct {
}

func Provide(conf DataServConfig) (*DataServ, error) {
	return &DataServ{}, nil
}

func (DataServ) ConfigName() string {
	return "data"
}

func (d *DataServ) AddUserEventLogPayload(userid int, payload datamodels.UserEventLogPayload) error {
	evlog := datamodels.NewUserEventLog(userid, payload)
	return d.AddUserEventLog(evlog)
}

func (d *DataServ) AddUserEventLog(evlog *datamodels.UserEventLog) error {
	return nil
}

func (d *DataServ) GetSimilarWords(userid int, word string) ([]datamodels.SimilarWord, error) {
	return nil, nil
}

func (d *DataServ) AddSystemEventLog(payload datamodels.SystemEventLogPayload) error {
	return nil
}
