package main

import (
	"fmt"
	"runtime"
)

func rtimes(c chan int, times int) {
	// sleep for a while to simulate time consumed by event
	fmt.Println("Started Testing: Should run", times, "times.")
	var count int
	for i := 0; i < times; i++ {
		count++
	}
	fmt.Println("Finished:", times, " times")
	c <- 1
}

func main() {
	runtime.GOMAXPROCS(4)
	var chs [5]chan int
	for i := 0; i < 5; i++ {
		chs[i] = make(chan int)
	}
	for i := 3; i > 0; i-- {
		go rtimes(chs[i-1], i*10000000000)
	}
	for i := 0; i < 5; i++ {
		<-chs[i]
	}
}
