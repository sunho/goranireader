package models

import "github.com/sunho/webf/wfdb"

type tx struct {
	*wfdb.Connection
}

func Tx(t *wfdb.Connection) *tx {
	return &tx{
		Connection: t,
	}
}

func (t *tx) GetBook(id int) (*Book, error) {
	var out Book
	err := t.Q().Where("id = ?", id).First(&out)
	if err != nil {
		return nil, err
	}

	return &out, nil
}

func (t *tx) GetUser(id int) (*User, error) {
	var out User
	err := t.Q().Eager().Where("id = ?", id).First(&out)
	if err != nil {
		return nil, err
	}
	return &out, nil
}

func (t *tx) GetMission(id int) (*ClassMission, error) {
	var out ClassMission
	err := t.Q().Where("id = ?", id).First(&out)
	if err != nil {
		return nil, err
	}
	return &out, nil
}

func (t *tx) GetClass(id int) (*Class, error) {
	var out Class
	err := t.Q().Where("id = ?", id).First(&out)
	if err != nil {
		return nil, err
	}
	return &out, nil
}
