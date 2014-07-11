package main

import (
	"code.google.com/p/go-uuid/uuid"
	"fmt"
	"github.com/Centny/Cny4go/log"
	"github.com/Centny/Cny4go/routing"
	"github.com/Centny/Cny4go/util"
	"net/http"
	"time"
)

func main() {
	fmt.Println(uuid.New())
	mux := routing.NewSessionMux2("")
	mux.ShowLog = true
	// mux.HFilterFunc("^/.*$", func(hs *routing.HTTPSession) routing.HResult {
	// 	hs.W.Header().Set("Access-Control-Allow-Origin", "*")
	// 	return routing.HRES_CONTINUE
	// })
	// mux.HFunc("^/org.cny.upload/test/upload(\\?.*)?$", Upload)
	mux.Handler("^/.*$", http.FileServer(http.Dir("src")))
	http.Handle("/", mux)
	fmt.Println("running")
	http.ListenAndServe(":8879", nil)
}

func Upload(hs *routing.HTTPSession) routing.HResult {
	hs.R.ParseForm()
	for k, v := range hs.R.Form {
		fmt.Println(k, v)
	}
	_, fh, err := hs.R.FormFile("file")
	fmt.Println(fh.Filename, fh.Header)
	for k, v := range fh.Header {
		fmt.Println(k, v)
	}
	fsize, fname, err := hs.FormFInfo("file")
	fmt.Println(fsize, fname, err)
	if err != nil {
		log.D("form file error:%v", err.Error())
		http.Error(hs.W, "NOT FOUND", http.StatusNoContent)
		return routing.HRES_RETURN
	}
	log.I("file size:%v,%v", fsize, err)
	hs.RecF("file", fmt.Sprintf("/tmp/%v", util.Timestamp(time.Now())))
	return routing.HRES_RETURN
}
