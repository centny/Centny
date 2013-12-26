package thttp

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"testing"
)

func TestDownload(t *testing.T) {
	fmt.Println("testing download ...")
	http.HandleFunc("/dl", handleDownload)
	http.ListenAndServe(":8000", nil)
}
func handleDownload(w http.ResponseWriter, r *http.Request) {
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
	w.Header().Set("Content-Type", "text/plain; charset=UTF-8")
	// w.Header().Set("mimetype", "application/octet-stream")
	w.Header().Set("Content-Disposition", "attachment;filename=测试.zip")
	w.Header().Set("Content-Length", fmt.Sprintf("%d", fi.Size()))
	w.Header().Set("ABC", "这是中文")
	fmt.Println("transfter file ...")
	io.Copy(w, f)
}
