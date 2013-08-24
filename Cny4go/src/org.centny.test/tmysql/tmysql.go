package main

import (
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"time"
)

func main() {
	// fmt.Println("aaaa")
	db, e := sql.Open("mysql", "cny:123@unix(/tmp/mysql.sock)/cny")
	if e != nil {
		fmt.Println("open database error", e)
		return
	}
	rows, err := db.Query("SELECT TID,NAME,TTIME FROM TT")
	if err != nil {
		fmt.Println("query error", err)
		return
	}
	for rows.Next() {
		var uid, name, ttime string
		if err := rows.Scan(&uid, &name, &ttime); err != nil {
			fmt.Println("err:", err)
		} else {
			t, err := time.Parse("2006-1-2 15:04:05", ttime)
			fmt.Printf("uid:%s,name:%s,info:%s\n", uid, name, t, err)
		}
	}
	db.Close()
	// fmt.Println("rows", rows)
}
