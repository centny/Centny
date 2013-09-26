--the param variable function
function pvf(name,...)
	--the ... array can be transfered to the table by {...}.
	--the {...} table transfer to ... array by using unpack({...}).
	print(string.format("this is %s test",name))
	local arg={...}
	for i,v in ipairs(arg)do
		print(string.format("idx:%d\t val:%s",i,v))
	end
end
function pvf2(...)
	pvf("pvf",...)
end

--value scope
function outerF()
	local oval=987
	return function()
		local ival=oval
		print(string.format("inner value:%d",ival))
	end
end
--call
--pvf2("a","b","c","d")
outerF()()