//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package dataserv

import (
	"gorani/models"
)

type DataServ struct {
	host string
}

func Provide() (*DataServ, error) {
	return &DataServ{}, nil
}

func (d *DataServ) AddUserEventLogPayload(userid int, payload models.UserEventLogPayload) error {
	evlog := models.NewUserEventLog(userid, payload)
	return d.AddUserEventLog(evlog)
}

func (d *DataServ) AddUserEventLog(evlog *models.UserEventLog) error {
	return nil
}

func (d *DataServ) GetSimilarWords(userid int, word string) ([]models.SimilarWord, error) {
	return nil, nil
}

func (d *DataServ) AddSystemEventLog(payload models.SystemEventLogPayload) error {
	return nil
}
