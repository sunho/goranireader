package dataserv

import (
	"gorani/models/datamodels"

	"github.com/gocql/gocql"
)

type DataServ struct {
	s *gocql.Session
}

func (d *DataServ) AddKnownWord(userid int, word string, n int) error {

}

func (d *DataServ) AddUserEventLog(userid int, payload datamodels.UserEventLogPayload) error {

}

func (d *DataServ) AddSystemEventLog(payload datamodels.SystemEventLogPayload) error {

}
