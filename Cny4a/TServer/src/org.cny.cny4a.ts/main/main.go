package main

import (
	"net/http"
	"org.cny.cny4a.ts/tdl"
)

func main() {
	tdl.Register()
	http.ListenAndServe(":8000", nil)
}
