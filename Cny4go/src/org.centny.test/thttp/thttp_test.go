package thttp

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"regexp"
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

type RegexpHandler struct {
}

func (h *RegexpHandler) Handler(pattern *regexp.Regexp, handler http.Handler) {
}

func (h *RegexpHandler) HandleFunc(pattern *regexp.Regexp, handler func(http.ResponseWriter, *http.Request)) {
}

func (h *RegexpHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Println("...........")
	// no pattern matched; send 404 response
	http.NotFound(w, r)
}
func TestServer(t *testing.T) {
	mux := http.NewServeMux()
	// mux.Handle("/api/", apiHandler{})
	mux.HandleFunc("/path/aa", func(w http.ResponseWriter, req *http.Request) {
		// The "/" pattern matches everything, so we need to check
		// that we're at the root here.
		// if req.URL.Path != "/" {
		// 	http.NotFound(w, req)
		// 	return
		// }
		fmt.Println("running ....")
		fmt.Fprintf(w, "Welcome to the home page!")
	})
	http.Handle("/path/", mux)
	http.ListenAndServe(":8080", nil)
}
