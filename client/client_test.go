package client

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestOriginAndCredentialBoundaries(t *testing.T) {
	good := Config{URL: "https://archinario.com", Session: "00000000-0000-4000-8000-000000000001", Token: strings.Repeat("a", 64)}
	for _, origin := range []string{"http://example.com", "https://name:secret@example.com", "https://example.com/?secret=x", "file:///tmp/x", "https://example.com/path"} {
		v := good
		v.URL = origin
		if _, e := New(v); e == nil {
			t.Fatal("unsafe origin accepted")
		}
	}
	for _, origin := range []string{"https://archinario.com", "http://127.0.0.1:3120", "http://localhost:3120"} {
		v := good
		v.URL = origin
		if _, e := New(v); e != nil {
			t.Fatal(e)
		}
	}
}
func TestCataloguePagesAndValidation(t *testing.T) {
	first, e := Catalog(CatalogInput{Limit: 2})
	if e != nil {
		t.Fatal(e)
	}
	second, _ := Catalog(CatalogInput{Limit: 2, Offset: 2})
	if first["nextOffset"] != 2 || len(first["items"].([]map[string]any)) != 2 || second["nextOffset"] != 4 {
		t.Fatal("pagination")
	}
	result, e := Catalog(CatalogInput{Query: "PostgreSQL"})
	if e != nil || result["total"].(int) < 1 {
		t.Fatal("technology search", e)
	}
	if _, e = Catalog(CatalogInput{Limit: 101}); e == nil {
		t.Fatal("unbounded read")
	}
}
func TestMalformedSnapshotDoesNotPanic(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		_ = json.NewEncoder(w).Encode(map[string]any{"revision": 1, "diagram": nil})
	}))
	defer srv.Close()
	c, e := New(Config{URL: srv.URL, Session: "00000000-0000-4000-8000-000000000001", Token: strings.Repeat("a", 64)})
	if e != nil {
		t.Fatal(e)
	}
	if _, e = c.Read(context.Background(), ReadInput{}); e == nil {
		t.Fatal("malformed response accepted")
	}
}
