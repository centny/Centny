-----define the function
function testFunc()
	local f1,f2;
	local e1=_ENV
	local e2=_ENV
	f1=createFunction(e1)
	f1()
	e2.a=9999
	f2=createFunction(e2)
	f2()
end
--
function createFunction(env)
	_ENV=env
	return function() print(a) end
end
--
function main()
	print(123)
end
------------------------------------------
a=700000
testFunc()
print("----the end----")