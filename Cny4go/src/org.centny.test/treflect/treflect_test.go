package treflect

import (
	"fmt"
	"net/http"
	"reflect"
	"testing"
)

type User struct {
	Id    int
	Name  string
	Age   int
	Title string
}

func (this User) Test() string {
	return this.Name
}

func TestReflect(t *testing.T) {
	var o interface{} = &User{1, "Tom", 12, "nan"}
	v := reflect.ValueOf(*http.DefaultServeMux)
	fmt.Println(v)
	vv := v.Field(1)
	http.HandleFunc("/abc", hmethod)
	fmt.Println(vv.Interface())
	// m := v.MethodByName("Test")
	// rets := m.Call([]reflect.Value{})
	// fmt.Println(rets)
	fmt.Println(o)
}

func hmethod(w http.ResponseWriter, r *http.Request) {

}
