package main

import (
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
)

func main() {
	// fmt.Println("aaaa")
	db, e := sql.Open("mysql", "cny:123@unix(/tmp/mysql.sock)/cny")
	if e != nil {
		fmt.Println("open database error", e)
		return
	}
	rows, err := db.Query("SELECT UID,NAME,INFO FROM T_USER")
	if err != nil {
		fmt.Println("query error", err)
		return
	}
	for rows.Next() {
		var uid, name, info string
		if err := rows.Scan(&uid, &name, &info); err != nil {
			fmt.Println("err:", err)
		} else {
			fmt.Printf("uid:%s,name:%s,info:%s\n", uid, name, info)
		}
	}
	db.Close()
	// fmt.Println("rows", rows)
}
