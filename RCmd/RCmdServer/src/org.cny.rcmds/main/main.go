package main

import (
	"bufio"
	"fmt"
	"github.com/Centny/Cny4go/util"
	"io"
	"io/ioutil"
	"net"
	"os"
	"os/exec"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("workspace directory is not setted")
		fmt.Println("Usage:cmd <command directory>")
		return
	}
	wdir := os.Args[1]
	cmds := make(map[string]string)
	fis, err := ioutil.ReadDir(wdir)
	if err != nil {
		panic(err)
	}
	for _, fi := range fis {
		cmds[fi.Name()] = "T"
	}
	if len(cmds) < 1 {
		fmt.Println("Warning:command not found in " + wdir)
	}
	os.RemoveAll("/tmp/rcm.sock")
	l, err := net.Listen("unix", "/tmp/rcm.sock")
	if err != nil {
		panic(err)
	}
	os.Chmod("/tmp/rcm.sock", os.ModePerm)
	for {
		ac, err := l.Accept()
		if err != nil {
			break
		}
		go func() {
			defer ac.Close()
			r := bufio.NewReader(ac)
			line, err := util.ReadLine(r, 1000, false)
			if err != nil {
				return
			}
			fmt.Println("running cmd(" + string(line) + ")")
			cmd := exec.Command(fmt.Sprintf("%s/%s", wdir, line))
			out_s, _ := cmd.StdoutPipe()
			err_s, _ := cmd.StderrPipe()
			if out_s != nil {
				go io.Copy(ac, out_s)
			}
			if err_s != nil {
				go io.Copy(ac, err_s)
			}
			err = cmd.Start()
			if err != nil {
				fmt.Fprintln(ac, err)
				return
			}
			cmd.Wait()
			fmt.Println("running cmd(" + string(line) + ") end ...")
		}()
	}
}
