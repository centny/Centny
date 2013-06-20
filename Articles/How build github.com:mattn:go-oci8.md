#How build github.com/mattn/go-oci8 (Go oracle driver)
====
##Create oci pkg-config
- download the *instantclient-basic-\** and *instantclient-sdk-\** package and uncompress to the sample directory.
- mv the *instanclient\** to */usr/lib*(or other postion).
- link the library file:
	
	```
	ln <instanclient path>/libclntsh.dylib.* /usr/lib/libclntsh.dylib.*
	ln <instanclient path>/libocci.dylib.* /usr/lib/libocci.dylib.*
	ln <instanclient path>/libociei.dylib /usr/lib/libociei.dylib
	ln <instanclient path>/libnnz11.dylib /usr/lib/libnnz11.dylib
	```
- install *pkg-config* if not installed.
- create *oci8.pc* file in */usr/lib/pkgconfig* and add blew(or download from <https://raw.github.com/Centny/Centny/master/Resources/oci8.pc>):


	```
	prefix=<replace instantclient path>
	libdir=${prefix}
	includedir=${prefix}/sdk/include/
	
	Name: OCI
	Description: Oracle database engine
	Version: 11.2
	Libs: -L${libdir} -lclntsh
	Libs.private: 
	Cflags: -I${includedir}

	```
	
##Build go-oci8
- go get github.com/mattn/go-oci8
- if have link error,check if instantclient package can be used for your system version and check pkg-config if correct.


##Test Connect
- cd <GOPATH>/src/github.com/mattn/go-oci8/example
- update oracle connection string in line:
	```
	db, err := sql.Open("oci8", "scott/tiger")
	```
- go run oracle.go
- if not error, install success