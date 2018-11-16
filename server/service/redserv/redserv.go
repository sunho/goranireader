package redserv

import "github.com/go-redis/redis"

type RedServ struct {
	cli *redis.Client
}

func New(addr string) (*RedServ, error) {
	cli := redis.NewClient(&redis.Options{
		Addr: addr,
	})
	_, err := cli.Ping().Result()
	if err != nil {
		return nil, err
	}

	return &RedServ{
		cli: cli,
	}, nil
}
