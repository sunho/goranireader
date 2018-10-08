package etl

import (
	"io/ioutil"

	"github.com/sunho/gorani-reader-server/go/pkg/gorani"
	yaml "gopkg.in/yaml.v2"
)

type Config struct {
	// gorani config is initialized by etl.New
	gorani.Config
	IsMaster              bool    `yaml:"is_master"`
	DotSpecialCasesJson   *string `yaml:"dot_special_cases_json`
	IrregularPastJson     *string `yaml:"irregular_past_json"`
	IrregularCompleteJson *string `yaml:"irregular_complete_json"`
}

func NewConfig(path string) (Config, error) {
	bytes, err := ioutil.ReadFile(path)
	if err != nil {
		return Config{}, err
	}

	conf := Config{}
	err = yaml.Unmarshal(bytes, &conf)
	if err != nil {
		return Config{}, err
	}

	return conf, nil
}
