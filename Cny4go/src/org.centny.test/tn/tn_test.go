package tn

import (
	"fmt"
	"os"
	"testing"
)

func TestOs(t *testing.T) {
	f, err := os.OpenFile("tt.log", os.O_CREATE|os.O_WRONLY, os.ModePerm)
	if err != nil {
		t.Error(err.Error())
		return
	}
	defer f.Close()
	os.Stdout = f
	fmt.Println("abcc")
}
