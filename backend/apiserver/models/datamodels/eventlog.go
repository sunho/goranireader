package datamodels

import (
	"gorani/utils"
	"time"
)

type UserEventLog struct {
	UserID  int       `db:"user_id" json:"-"`
	Day     time.Time `db:"day" json:"-"`
	Kind    string    `db:"kind" json:"kind"`
	Time    time.Time `db:"time" json:"time"`
	Payload string    `db:"payload" json:"payload"`
}

type UserEventLogPayload interface {
	Payload() string
	Kind() string
	sealed()
}

func NewUserEventLog(userid int, payload UserEventLogPayload) *UserEventLog {
	return &UserEventLog{
		UserID:  userid,
		Day:     utils.RoundTime(time.Now()),
		Payload: payload.Payload(),
		Time:    time.Now(),
		Kind:    payload.Kind(),
	}
}

type SystemEventLog struct {
	Day     time.Time `db:"day"`
	Kind    string    `db:"kind"`
	Time    time.Time `db:"time"`
	Payload string    `db:"payload"`
}

type SystemEventLogPayload interface {
	Payload() string
	Kind() string
	sealed()
}

func NewSystemEventLog(payload SystemEventLogPayload) *SystemEventLog {
	return &SystemEventLog{
		Day:     utils.RoundTime(time.Now()),
		Time:    time.Now(),
		Kind:    payload.Kind(),
		Payload: payload.Payload(),
	}
}
