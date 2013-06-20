package tcode

import (
	"fmt"
	"os"
)

func ShowPwd() {
	fmt.Println(os.Getwd())
}

func ShowLog() {
	for i := 0; i < 10; i++ {
		fmt.Println("idx:", i)
	}
}

func ShowSome() {
	fmt.Println("calling show some...")
}
