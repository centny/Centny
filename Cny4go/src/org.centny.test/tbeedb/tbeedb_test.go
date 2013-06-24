package tbeedb

import (
	"database/sql"
	"fmt"
	"github.com/astaxie/beedb"
	_ "github.com/go-sql-driver/mysql"
	"testing"
)

type TUser struct {
	Uid  int `beedb:"PK"` //id is auto increment.
	Name string
	Info string
}

var db *sql.DB
var orm beedb.Model
var err error

func init() {
	beedb.OnDebug = true
	fmt.Println("the initialtion function...")
	db, err = sql.Open("mysql", "cny:123@unix(/tmp/mysql.sock)/cny")
	orm = beedb.New(db)
}

func TestSave(t *testing.T) {
	orm := beedb.New(db)
	var tu TUser
	tu.Name = "test name"
	tu.Info = "testing"
	err = orm.Save(&tu)
	if err != nil {
		panic(err)
	}
}
func TestFetch(t *testing.T) {
	var tu TUser
	// orm.Where(querystring, ...)
}
