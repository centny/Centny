package main

import (
	"fmt"
)

//normal function
func nfunc(x int, y int) int {
	return x * y
}

//multiple results function
func swap(x, y string) (string, string) {
	return y, x
}

//named results
func split(sum int) (x, y int) {
	x = sum * 4 / 9
	y = sum - x
	return
}
func main() {
	// fmt.Println(nfunc(10, 12))
	//
	// x := "X"
	// y := "Y"
	// fmt.Println(swap(x, y))
	//
	// fmt.Println(split(10))
	//
	// var abc int
	// fmt.Println(abc)
	//
	// var a, b, c = 1, "2", false
	// fmt.Println(a, b, c)
	//
}
