//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package utils

import "github.com/google/uuid"

func UuidToBytes(id uuid.UUID) []byte {
	bytes := [16]byte(id)
	bytes2 := make([]byte, 16)
	copy(bytes2, bytes[:16])
	return bytes2
}
