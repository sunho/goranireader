//https://github.com/gobuffalo/pop/blob/master/model.go

package dbserv

import (
	"fmt"
	"reflect"
	"strings"

	"github.com/sunho/pop"
)

type Model struct {
	Value interface{}
}

func (m *Model) getType() (reflect.Type, reflect.Value) {
	v := reflect.ValueOf(m.Value)
	v = reflect.Indirect(v)
	t := v.Type()
	return t, v
}

func (m *Model) new() interface{} {
	t, _ := m.getType()
	return reflect.New(t).Interface()
}

type primaryKey struct {
	structName string
	dbName     string
}

func (m *Model) primaryKeys() []primaryKey {
	t, _ := m.getType()
	out := []primaryKey{}
	for i := 0; i < t.NumField(); i++ {
		f := t.Field(i)
		if f.Tag.Get("pk") == "true" {
			out = append(out, primaryKey{dbName: f.Tag.Get("db"), structName: f.Name})
		}
	}
	return out
}

func (m *Model) fieldByName(s string) (reflect.Value, error) {
	el := reflect.ValueOf(m.Value).Elem()
	fbn := el.FieldByName(s)
	if !fbn.IsValid() {
		return fbn, fmt.Errorf("Model does not have a field named %s", s)
	}
	return fbn, nil
}

func (m *Model) GetField(name string) interface{} {
	fbn, err := m.fieldByName(name)
	if err != nil {
		return 0
	}
	return fbn.Interface()
}

func (m *Model) FieldType(name string) string {
	fbn, err := m.fieldByName(name)
	if err != nil {
		return "int"
	}
	return fbn.Type().Name()
}

func (m *Model) setID(i interface{}) {
	fbn, err := m.fieldByName("ID")
	if err == nil {
		v := reflect.ValueOf(i)
		switch fbn.Kind() {
		case reflect.Int, reflect.Int64:
			fbn.SetInt(v.Int())
		default:
			fbn.Set(reflect.ValueOf(i))
		}
	}
}

func (m *Model) wherePrimary(q *pop.Query) *pop.Query {
	pks := m.primaryKeys()
	arr := make([]string, 0, len(pks))
	phs := make([]interface{}, 0, len(pks))
	for _, pk := range pks {
		arr = append(arr, fmt.Sprintf("%s = ?", pk.dbName))
		phs = append(phs, m.GetField(pk.structName))
	}
	stmt := strings.Join(arr, " and ")
	return q.Where(stmt, phs...)
}
