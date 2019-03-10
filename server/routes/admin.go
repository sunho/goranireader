package routes

func (a *AdminServ) InitialSens(file *multipart.FileHeader) ([]byte, error) {
	r, err := file.Open()
	if err != nil {
		return nil, err
	}
	defer r.Close()
	b, err := bookparse.Parse("", r, file.Size)
	if err != nil {
		return nil, err
	}
	out, err := sens.NewFromBook(b)
	return out.Encode(), err
}

func (a *AdminServ) UploadEpub(bookid int, file *multipart.FileHeader) error {
	r, err := file.Open()
	if err != nil {
		return err
	}
	defer r.Close()
	b, err := bookparse.Parse("", r, file.Size)
	if err != nil {
		return err
	}

	r2, err := file.Open()
	if err != nil {
		return err
	}
	defer r2.Close()
}
