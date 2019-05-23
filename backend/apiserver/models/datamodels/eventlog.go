//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package datamodels

import (
	"gorani/utils"
	"time"
)

type UserEventLog struct {
	UserID  int       `db:"user_id" json:"user_id"`
	Day     time.Time `db:"day" json:"day"`
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
		Day:     utils.RoundTime(time.Now().UTC()),
		Payload: payload.Payload(),
		Time:    time.Now().UTC(),
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
		Day:     utils.RoundTime(time.Now().UTC()),
		Time:    time.Now().UTC(),
		Kind:    payload.Kind(),
		Payload: payload.Payload(),
	}
}
