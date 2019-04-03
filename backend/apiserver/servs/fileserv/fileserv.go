package fileserv

import (
	"gorani/utils"
	"io"
	"mime/multipart"
	"path/filepath"
	"strconv"
	"time"

	"github.com/minio/minio-go"
)

type FileServConf struct {
	Endpoint string `yaml:"endpoint"`
	Key      string `yaml:"key"`
	Secret   string `yaml:"secret"`
	Region   string `yaml:"region"`
	Bucket   string `yaml:"bucket"`
}

type FileServ struct {
	bucket   string
	endpoint string
	cli      *minio.Client
}

func Provide(conf FileServConf) (*FileServ, error) {
	cli, err := minio.New(conf.Endpoint, conf.Key, conf.Secret, false)
	if err != nil {
		return nil, err
	}
	err = cli.MakeBucket(conf.Bucket, conf.Region)
	if err != nil {
		exists, err := cli.BucketExists(conf.Bucket)
		if err != nil || !exists {
			return nil, err
		}
	}
	policy := `{"Version": "2012-10-17","Statement": [{"Action": ["s3:GetObject"],"Effect": "Allow","Principal": {"AWS": ["*"]},"Resource": ["arn:aws:s3:::` + conf.Bucket + `/*"],"Sid": ""}]}`
	err = cli.SetBucketPolicy(conf.Bucket, policy)
	if err != nil {
		return nil, err
	}
	return &FileServ{
		cli:      cli,
		endpoint: conf.Endpoint,
		bucket:   conf.Bucket,
	}, err
}

func (FileServ) ConfigName() string {
	return "file"
}

func (s *FileServ) UploadFileHeader(f *multipart.FileHeader) (string, error) {
	r, err := f.Open()
	if err != nil {
		return "", err
	}
	defer r.Close()
	return s.UploadFile(r, f.Header.Get("Content-Type"), filepath.Ext(f.Filename))
}

func (s *FileServ) UploadFile(r io.Reader, contentType string, ext string) (string, error) {
	key := strconv.Itoa(int(time.Now().UTC().UnixNano())) + utils.RandString(30) + ext
	_, err := s.cli.PutObject(s.bucket, key, r, -1, minio.PutObjectOptions{ContentType: contentType})
	if err != nil {
		return "", err
	}

	return "https://" + s.endpoint + "/" + s.bucket + "/" + key, nil
}
