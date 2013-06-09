package main

import (
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
)

func main() {
	// fmt.Println("aaaa")
	db, e := sql.Open("mysql", "root:sco@unix(/tmp/mysql.sock)/test")
	if e != nil {
		fmt.Println("open database error", e)
		return
	}
	rows, err := db.Query("SELECT * FROM TNAME")
	if err != nil {
		fmt.Println("query error", err)
		return
	}
	for rows.Next() {
		var aid, bid string
		if err := rows.Scan(&aid, &bid); err != nil {
			fmt.Println("err:", err)
		} else {
			fmt.Printf("aid:%s,bid:%s\n", aid, bid)
		}
	}
	db.Close()
	// fmt.Println("rows", rows)
}
