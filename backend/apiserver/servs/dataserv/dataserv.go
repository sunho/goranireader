package dataserv

import (
	"gorani/models/datamodels"

	"github.com/gocql/gocql"
)

type DataServ struct {
	s *gocql.Session
}

func Provide() (*DataServ, error) {
	cluster := gocql.NewCluster("127.0.0.1")
	cluster.Keyspace = "gorani"
	s, err := cluster.CreateSession()
	if err != nil {
		return nil, err
	}
	return &DataServ{
		s: s,
	}, nil
}

func (d *DataServ) AddKnownWord(userid int, word string, n int) error {
	return d.s.Query(`update known_words set n = n + ? where word = ? and user_id = ?`, n, word, userid).Exec()
}

func (d *DataServ) AddUserEventLogPayload(userid int, payload datamodels.UserEventLogPayload) error {
	evlog := datamodels.NewUserEventLog(userid, payload)
	return d.AddUserEventLog(evlog)
}

func (d *DataServ) AddUserEventLog(evlog *datamodels.UserEventLog) error {
	id := gocql.TimeUUID()
	err := d.s.Query(`insert into user_event_day_logs (id, user_id, day, kind, time, payload) VALUES(?, ?, ?, ?, ?, ?)`,
		id,
		evlog.UserID,
		evlog.Day,
		evlog.Kind,
		evlog.Time,
		evlog.Payload,
	).Exec()
	if err != nil {
		return err
	}
	return d.s.Query(`insert into user_event_kind_logs (id, user_id, day, kind, time, payload) VALUES(?, ?, ?, ?, ?, ?)`,
		id,
		evlog.UserID,
		evlog.Day,
		evlog.Kind,
		evlog.Time,
		evlog.Payload,
	).Exec()
}

func (d *DataServ) AddSystemEventLog(payload datamodels.SystemEventLogPayload) error {
	return nil
}
