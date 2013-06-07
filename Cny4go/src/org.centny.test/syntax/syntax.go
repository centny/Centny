package main

import (
	"fmt"
	"math"
	"net/http"
	"runtime"
	"time"
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

//constants
const Pi = 3.14
const (
	Ca = 100
	Cb = "sss"
)

//go loop
func goloop() {
	for i := 0; i < 10; i++ {
		fmt.Println("for:", i)
	}
	//use like while
	k := 0
	for k < 10 {
		fmt.Println("while:", k)
		k++
	}
	//forever
	for {
		break
	}
}

//if statement
func ifstate() {
	if 10 > 5 {
		fmt.Println("more")
	}
	//if before condition
	v := 11
	if i := v % 2; i > 0 {
		fmt.Println("condition")
	} else {
		fmt.Println("condition not")
	}
}

//use struct
type Point struct {
	X int
	Y int
}

//slices
func slices() {
	ary := []int{10, 2, 4, 5, 6, 6}
	fmt.Println(ary)
	for i := 0; i < len(ary); i++ {
		fmt.Printf("ary[%d]:%d\n", i, ary[i])
	}
	fmt.Println(ary[:3])
	fmt.Println(ary[0:3])
	fmt.Println(ary[3:4])
	fmt.Println(ary[3:])
	//
	a := make([]int, 5)
	fmt.Println(a)
	fmt.Println(len(a))
	b := make([]int, 0, 15)
	fmt.Println(b)
	fmt.Println(len(b))
	fmt.Println(cap(b))
	//
	var z []int
	fmt.Println(z, len(z), cap(z))
	if z == nil {
		fmt.Println("nil!")
	}
}

//range
func rangeSet() {
	ary := []int{10, 2, 4, 5, 6, 6}
	for i, v := range ary {
		fmt.Printf("%d:%d\n", i, v)
	}
	for i := range ary {
		ary[i] = 1 << uint(i)
	}
	for _, value := range ary {
		fmt.Printf("%d\n", value)
	}
}

//map
func mapVal() {
	m := make(map[string]string)
	m["a"] = "100"
	m["b"] = "200"
	fmt.Println(m)
	var ma = map[string]Point{
		"c": Point{100, 10},
		"d": Point{10, 80},
		"e": {10, 80},
	}
	fmt.Println(ma, ma["e"].X)
	delete(ma, "c")
	fmt.Println("The value:", m["c"])
	v, ok := ma["d"] //test the value if exist in ma
	fmt.Println("The value:", v, "Present?", ok)
}

//value function
func valFunc() {
	funa := func(a, b int) (int, int) {
		return b, a
	}
	fmt.Println(funa(10, 40))
}

//function closures
func adder() func(int) int {
	sum := 0
	return func(x int) int {
		sum += x
		return sum
	}
}
func closures() {
	pos, neg := adder(), adder()
	for i := 0; i < 10; i++ {
		fmt.Println(
			pos(i),
			neg(-2*i),
		)
	}
}

//switch
func tswitch() {
	fmt.Print("Go runs on ")
	switch os := runtime.GOOS; os {
	case "darwin":
		fmt.Println("OS X.")
	case "linux":
		fmt.Println("Linux.")
	default:
		// freebsd, openbsd,
		// plan9, windows...
		fmt.Printf("%s.", os)
	}
	//
	fmt.Println("When's Saturday?")
	today := time.Now().Weekday()
	switch time.Saturday {
	case today + 0:
		fmt.Println("Today.")
	case today + 1:
		fmt.Println("Tomorrow.")
	case today + 2:
		fmt.Println("In two days.")
	default:
		fmt.Println("Too far away.")
	}
	//
	swfunc := func(v int) int {
		fmt.Println("val:", v)
		return 5
	}
	for i := 0; i < 10; i++ {
		switch i {
		case 0:
			fmt.Println("value first")
		case swfunc(i):
			fmt.Println("match function")
		default:
			fmt.Println("default vaule")
		}
	}
	//no condition
	t := time.Now()
	switch {
	case t.Hour() < 12:
		fmt.Println("Good morning!")
	case t.Hour() < 17:
		fmt.Println("Good afternoon.")
	default:
		fmt.Println("Good evening.")
	}
}

//struct method
func (this *Point) Abs() float64 {
	return math.Sqrt((float64)(this.X*this.X + this.Y*this.Y))
}
func (this *Point) Poor() float64 {
	if this.X > this.Y {
		return (float64)(this.X - this.Y)
	} else {
		return (float64)(this.Y - this.X)
	}
}

type MyFloat float64

func (f MyFloat) Abs() float64 {
	if f < 0 {
		return float64(-f)
	}
	return float64(f)
}
func (f *MyFloat) x2() {
	*f = *f * 2
}

type Abser interface {
	Abs() float64
}
type Poorer interface {
	Poor() float64
}
type AbsPoorer interface {
	Abser
	Poorer
}

func tinterface() {
	var a Abser
	f := MyFloat(-math.Sqrt2)
	v := Point{3, 4}

	a = f // a MyFloat implements Abser
	fmt.Println(a.Abs())
	a = &v // a *Vertex implements Abser
	// a = v  // a Vertex, does NOT
	// implement Abser

	fmt.Println(a.Abs())
	var b AbsPoorer
	b = &v
	fmt.Println(b.Abs())
	fmt.Println(b.Poor())
}

//error
type MyError struct {
	When time.Time
	What string
}

func (e *MyError) Error() string {
	return fmt.Sprintf("at %v, %s",
		e.When, e.What)
}

func terror() {
	er := &MyError{
		time.Now(),
		"it didn't work",
	}
	fmt.Println(er)
}

//http server
type HelloHttp struct{}

func (h HelloHttp) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "Hello!")
}
func httpServer() {
	var h HelloHttp
	http.ListenAndServe("localhost:4000", h)
}

func main() {
	httpServer()
	//
	// terror()
	//
	// tinterface()
	//
	// var mf MyFloat = 100
	// fmt.Println(mf.Abs())
	// mf.x2()
	// fmt.Println(mf)
	//
	// pv := Point{3, 4}
	// fmt.Println(pv.Abs())
	//
	// tswitch()
	//
	// fmt.Println(split(10))
	//
	// closures()
	//
	// valFunc()
	//
	// mapVal()
	//
	// rangeSet()
	//
	//
	// slices()
	//
	// v := new(Point)
	// fmt.Println(v)
	// v.X, v.Y = 100, 8
	// fmt.Println(v)
	//
	// sb := &sa
	// sb.X = 10
	// fmt.Println("Point:", sa, sa.X, sa.Y)
	//
	// sa := Point{100, 100}
	// fmt.Println("Point:", sa, sa.X, sa.Y)
	// ifstate()
	//
	// goloop()
	//
	// fmt.Println("Pi:", Pi, Ca, Cb)
	//
	// var a, b, c = 1, "2", false
	// fmt.Println(a, b, c)
	//
	// var abc int
	// fmt.Println(abc)
	//
	// fmt.Println(nfunc(10, 12))
	//
	// x := "X"
	// y := "Y"
	// fmt.Println(swap(x, y))
	//
}
