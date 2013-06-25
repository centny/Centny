package main

import (
	"fmt"
	"runtime"
	"sync"
	"time"
)

var mux sync.Mutex
var vv string = "ssssss"

//go
func say(c chan int, s string) {
	for i := 0; i < 5; i++ {
		time.Sleep(time.Millisecond)
		// mux.Lock()
		fmt.Println(s, vv)
		// mux.Unlock()
	}
	c <- 1
}

func gosay() {
	c1 := make(chan int)
	c2 := make(chan int)
	go say(c1, "Hello")
	go say(c2, "world")
	<-c1
	<-c2

}
func main() {
	runtime.GOMAXPROCS(4)
	gosay()
}
