package ticonv

import (
	"fmt"
	iconv "github.com/djimenez/iconv-go"
	"testing"
)

func TestIconv(t *testing.T) {
	output, _ := iconv.ConvertString("这是中文", "utf-8", "windows-1252")
	fmt.Println(output)
}
