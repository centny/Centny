package main

import (
	"fmt"
	"runtime"
)

func rtimes(c chan int, times int) {
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
	const C_SIZE int = 3
	var chs [C_SIZE]chan int
	for i := 0; i < C_SIZE; i++ {
		chs[i] = make(chan int)
	}
	for i := C_SIZE; i > 0; i-- {
		go rtimes(chs[i-1], i*10000000)
	}
	for i := 0; i < C_SIZE; i++ {
		<-chs[i]
	}
	dd
}
