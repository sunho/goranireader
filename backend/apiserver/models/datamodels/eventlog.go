package datamodels

import (
	"time"
)

type UserEventLog struct {
	UserID  int       `cql:"userid"`
	Day     time.Time `cql:"day"`
	Kind    string    `cql:"kind"`
	Time    time.Time `cql:"time"`
	Payload string    `cql:"payload"`
}

type UserEventLogPayload interface {
	Type() string
	Kind() string
	sealed()
}

func NewUserEventLog(userid int, payload UserEventLogPayload) *UserEventLog {
	return &UserEventLog{
		UserID: userid,
		Kind:   payload.Kind(),
	}
}

type SystemEventLog struct {
	Day     time.Time `cql:"day"`
	Kind    string    `cql:"kind"`
	Time    time.Time `cql:"time"`
	Payload string    `cql:"payload"`
}

type SystemEventLogPayload interface {
	Type() string
	Kind() string
	sealed()
}

func NewSystemEventLog(payload SystemEventLogPayload) *SystemEventLog {
	return &SystemEventLog{
		Kind: payload.Kind(),
	}
}
