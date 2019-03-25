package utils

import (
	"database/sql/driver"
	"encoding/json"
	"errors"
)

// google.... please give me generics...........;;;..;;

/*

func (s @) Value() (driver.Value, error) {
	str, err := json.Marshal(s)
	if err != nil {
		return nil, err
	}
	return driver.Value(str), nil
}

func (s *@) Scan(i interface{}) error {
	var src []byte
	switch i.(type) {
	case string:
		src = []byte(i.(string))
	case []byte:
		src = i.([]byte)
	default:
		return errors.New("Incompatible type for Cord")
	}
	return json.Unmarshal(src, s)
}

*/

type SQLStrings []string

func (s SQLStrings) Value() (driver.Value, error) {
	str, err := json.Marshal(s)
	if err != nil {
		return nil, err
	}
	return driver.Value(str), nil
}

func (s *SQLStrings) Scan(i interface{}) error {
	var src []byte
	switch i.(type) {
	case string:
		src = []byte(i.(string))
	case []byte:
		src = i.([]byte)
	default:
		return errors.New("Incompatible type for Cord")
	}
	return json.Unmarshal(src, s)
}

type SQLInts []int

func (s SQLInts) Value() (driver.Value, error) {
	str, err := json.Marshal(s)
	if err != nil {
		return nil, err
	}
	return driver.Value(str), nil
}

func (s *SQLInts) Scan(i interface{}) error {
	var src []byte
	switch i.(type) {
	case string:
		src = []byte(i.(string))
	case []byte:
		src = i.([]byte)
	default:
		return errors.New("Incompatible type for Cord")
	}
	return json.Unmarshal(src, s)
}
