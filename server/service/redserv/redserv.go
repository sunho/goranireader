package redserv

import "github.com/go-redis/redis"

type RedServ struct {
	cli *redis.Client
}

func (RedServ) ConfigName() string {
	return "red"
}

type RedServConf struct {
	Addr string `yaml:"addr"`
}

func Provide(conf RedServConf) (*RedServ, error) {
	cli := redis.NewClient(&redis.Options{
		Addr: conf.Addr,
	})
	_, err := cli.Ping().Result()
	if err != nil {
		return nil, err
	}

	return &RedServ{
		cli: cli,
	}, nil
}
