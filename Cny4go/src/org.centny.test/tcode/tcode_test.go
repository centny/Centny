package tcode

import (
	"fmt"
	"testing"
)

func TestShowPwd(t *testing.T) {
	ShowPwd()
}

func TestShowLog(t *testing.T) {
	ShowLog()
}

func TestChinese(t *testing.T) {
	ShowChinese()
}
func TestShow(t *testing.T) {
	for i := 0; i < 10; i++ {
		fmt.Println("1")
		fmt.Println("2")
		fmt.Println("3")
		fmt.Println("4")
	}
}
