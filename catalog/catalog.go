// Package catalog embeds the role snapshot shipped with this agent release.
package catalog

import (
	_ "embed"
	"encoding/json"
)

//go:embed components.json
var raw []byte

func JSON() json.RawMessage { return append(json.RawMessage(nil), raw...) }
