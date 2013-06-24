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

func (self *TUser) Show() {
	fmt.Printf("uid:%d,name:%s,info:%s", self.Uid, self.Name, self.Info)
}

var db *sql.DB
var orm beedb.Model
var err error

func init() {
	beedb.OnDebug = false
	// fmt.Println("the initialtion function...")
	db, err = sql.Open("mysql", "cny:123@unix(/tmp/mysql.sock)/cny")
	orm = beedb.New(db)
}

func TestSave(t *testing.T) {
	for i := 0; i < 10; i++ {
		var tu TUser
		tu.Name = fmt.Sprintf("test_%d", i)
		tu.Info = "testing"
		err = orm.Save(&tu)
		if err != nil {
			panic(err)
		}
	}
}
func TestFetch(t *testing.T) {
	var tu TUser
	err = orm.Where("name=?", fmt.Sprintf("test_%d", 2)).Find(&tu)
	if err != nil {
		panic(err)
	}
	tu.Show()
	fmt.Println()
}

func TestFetchMObjs(t *testing.T) {
	var tus []TUser
	err = orm.Where("uid>?", 2).FindAll(&tus)
	var i int
	var val TUser
	for i, val = range tus {
		fmt.Printf("idx:%d,", i)
		val.Show()
		fmt.Println()
	}
}
func TestDelete(t *testing.T) {
	var tu TUser
	var res int64
	tu.Uid = 2
	res, err = orm.Delete(&tu)
	if err != nil {
		panic(err)
	}
	fmt.Printf("affected line:%d\n", res)
}
func TestExecute(t *testing.T) {
	var sres sql.Result
	sres, err = orm.Exec("delete from t_user where uid>?", 2)
	var res int64
	res, err = sres.RowsAffected()
	fmt.Printf("affected line:%d\n", res)
}
