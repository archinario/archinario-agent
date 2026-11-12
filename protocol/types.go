// Package protocol defines the versioned Archinario board-agent wire contract.
package protocol

import "encoding/json"

const MaxBytes = 256 * 1024

type Object = map[string]any

// Patch merges existing objects by UUID; a new object needs id,kind,x,y (nodes)
// or id,source,target (edges). Other new-object defaults follow the shared catalogue.
type Patch struct {
	UpsertNodes   []Object `json:"upsertNodes,omitempty"`
	UpsertEdges   []Object `json:"upsertEdges,omitempty"`
	DeleteNodeIDs []string `json:"deleteNodeIds,omitempty"`
	DeleteEdgeIDs []string `json:"deleteEdgeIds,omitempty"`
	Title         *string  `json:"title,omitempty"`
}
type ApplyInput struct {
	RequestID        string `json:"requestId" jsonschema:"Unique request identity; reuse only to retry the identical request"`
	ExpectedRevision int    `json:"expectedRevision" jsonschema:"Revision from board_read; conflicts require a fresh read"`
	Patch            Patch  `json:"patch"`
	DryRun           bool   `json:"dryRun,omitempty"`
}

type Receipt struct {
	RequestID string          `json:"requestId"`
	Status    string          `json:"status"`
	Revision  int             `json:"revision"`
	Error     string          `json:"error,omitempty"`
	Diagram   json.RawMessage `json:"diagram,omitempty"`
}

// ValidRequestID keeps retry identities portable across URL paths and clients.
func ValidRequestID(id string) bool {
	if len(id) < 1 || len(id) > 80 {
		return false
	}
	for _, c := range id {
		if !(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9' || c == '-' || c == '_') {
			return false
		}
	}
	return true
}
