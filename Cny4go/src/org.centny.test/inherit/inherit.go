package main

import (
	"fmt"
)

type Z struct {
	z string
}

func (z Z) HelloA() {
	fmt.Println("z helloA")
	fmt.Println(z.z)

}

func (z Z) HelloZ() {
	fmt.Println("z helloz")
	fmt.Println(z.z)
}

//Z 和a 的次序貌似没有关系,不想有些文章写的
type A struct {
	a string
	Z
}

func (a A) HelloA() {
	fmt.Println("hello a")
	fmt.Println(a.a)
	//调用父类方法方式1
	a.Z.HelloA()
	a.HelloZ()
	//调用父类方法方式2
	z := Z(a.Z)
	z.HelloA()
	//不能直接 HelloZ() 这个是为什么?有点不解
	z.HelloZ()
}

type B struct {
	b string
}

func (b B) HelloB() {
	fmt.Println("hello b")
	fmt.Println(b.b)
}

type C struct {
	A
	B
}

func main() {
	c := &C{}
	c.a = "a"
	c.b = "b"
	c.z = "z"

	c.HelloA()
	c.HelloB()
	c.HelloZ()
}
