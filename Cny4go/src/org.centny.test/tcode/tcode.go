package tcode

import (
	"fmt"
	"os"
	"sync"
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

type TPoint struct {
	X   int
	Y   int
	mux sync.Mutex
}

func (self *TPoint) SaySome(v string) {
	for i := 0; i < 20; i++ {
		fmt.Println(v)
	}
}

func ShowChinese() {
	for i := 0; i < 10; i++ {
		fmt.Println("这是中文")
	}
}
