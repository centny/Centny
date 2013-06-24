package toracle

import (
	"database/sql"
	"fmt"
	_ "github.com/mattn/go-oci8"
	"os"
	"testing"
)

func TestM(t *testing.T) {
	os.Setenv("NLS_LANG", "")

	db, err := sql.Open("oci8", "exgTraceUser/ex_JU2!7@qnear.com:21521/KDB")
	if err != nil {
		fmt.Println(err)
		return
	}
	rows, err := db.Query("select 3.14, 'foo' from dual")
	if err != nil {
		fmt.Println(err)
		return
	}
	for rows.Next() {
		var f1 float64
		var f2 string
		rows.Scan(&f1, &f2)
		println(f1, f2) // 3.14 foo
	}
	rows.Close()
	_, err = db.Exec("create table foo(bar varchar2(256))")
	_, err = db.Exec("drop table foo")
	if err != nil {
		fmt.Println(err)
		return
	}
	db.Close()
}
