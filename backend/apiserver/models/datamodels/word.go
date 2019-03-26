package datamodels

type KnownWord struct {
	UserID int    `cql:"userid"`
	Word   string `cql:"word"`
	N      int    `cql:"n"`
}
