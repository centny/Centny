package main

import (
	"bufio"
	"fmt"
	"github.com/Centny/Cny4go/util"
	"net"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage:rcm cmd")
		os.Exit(-1)
	}
	con, err := net.Dial("unix", "/tmp/rcm.sock")
	if err != nil {
		fmt.Println(os.Stderr, err.Error())
		os.Exit(-1)
	}
	defer con.Close()
	r := bufio.NewReader(con)
	_, err = con.Write([]byte(os.Args[1] + "\n"))
	if err != nil {
		fmt.Println(os.Stderr, err.Error())
		os.Exit(-1)
	}
	for {
		lin, err := util.ReadLine(r, 1000, false)
		if err != nil {
			break
		}
		fmt.Println(string(lin))
	}
}
