package tdl

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strconv"
)

func Register() {
	fmt.Println("registering all downloa handle ...")
	http.HandleFunc("/dl", hdl_n)
}
func hdl_n(w http.ResponseWriter, r *http.Request) {
	sw := r.FormValue("sw")
	swi, err := strconv.Atoi(sw)
	if err != nil {
		w.Write([]byte(err.Error()))
	} else {
		tran_f(w, r, swi)
	}
}
func tran_f(w http.ResponseWriter, r *http.Request, sw int) {
	fpath := "../../../data/www.pdf"
	f, err := os.Open(fpath)
	if err != nil {
		w.Write([]byte("error:" + err.Error()))
		return
	}
	fi, err := f.Stat()
	if err != nil {
		w.Write([]byte("error:" + err.Error()))
		return
	}
	fmt.Println(fmt.Sprintf("sw:%d", sw))
	switch sw {
	case 1:
		w.Header().Set("Content-Type", "text/plain; charset=UTF-8")
		w.Header().Set("Content-Disposition", "attachment;filename=测试.pdf")
		w.Header().Set("Content-Length", fmt.Sprintf("%d", fi.Size()))
		w.Header().Set("ABC", "这是中文")
		break
	case 2:
		w.Header().Set("Content-Type", "text/plain;")
		w.Header().Set("Content-Disposition", "attachment;filename=测试.pdf")
		w.Header().Set("Content-Length", fmt.Sprintf("%d", fi.Size()))
		w.Header().Set("ABC", "这是中文")
		break
	case 3:
		// w.Header().Set("Content-Type", "text/plain;")
		w.Header().Set("Content-Disposition", "attachment;filename=测试.pdf")
		w.Header().Set("Content-Length", fmt.Sprintf("%d", fi.Size()))
		w.Header().Set("ABC", "这是中文")
		break
	case 4:
		w.Header().Set("Content-Type", "text/plain; charset=UTF-8")
		w.Header().Set("Content-Disposition", "attachment;filename=测试.pdf")
		// w.Header().Set("Content-Length", fmt.Sprintf("%d", fi.Size()))
		w.Header().Set("ABC", "这是中文")
		break
	case 5:
		w.Header().Set("Content-Type", "text/plain; charset=UTF-8")
		// w.Header().Set("Content-Disposition", "attachment;filename=测试.pdf")
		w.Header().Set("Content-Length", fmt.Sprintf("%d", fi.Size()))
		w.Header().Set("ABC", "这是中文")
		break
	}
	fmt.Println("transfter file ...")
	io.Copy(w, f)
}
