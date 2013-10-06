//
//  NSLua.m
//  XEP
//
//  Created by Wen ShaoHong on 10/13/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "NSLua.h"

@implementation NSLua
@synthesize l = _l;
+ (id)luaWithFile:(const char *)file
{
	return [[[NSLua alloc] initWithFile:file] autorelease];
}

- (id)initWithFile:(const char *)file
{
	self = [self init];

	if (self) {
		[self dofile:file];
	}

	return self;
}
- (id)initWithFile:(const char *)file spath:(const char*)sp{
    self=[self init];
    if(self){
        [self addSearchPath:sp];
        [self dofile:file];
    }
    return self;
}
- (id)init
{
	self = [super self];

	if (self) {
		_l = luaL_newstate();
        luaopen_package(_l);
		luaL_openlibs(_l);
	}

	return self;
}
- (void)addSearchPath:(const char *)spath{
    lua_getglobal(_l, "package" );
    lua_getfield(_l, -1, "path" ); // get field "path" from table at top of stack (-1)
    NSString* cpath=[NSString stringWithFormat:@"%s;%s",lua_tostring(_l, -1 ),spath];
    lua_pop( _l, 1 ); // get rid of the string on the stack we just pushed on line 5
    lua_pushstring(_l, [cpath UTF8String]); // push the new one
    lua_setfield(_l, -2, "path" ); // set the field "path" in table at -2 with value at top of stack
    lua_pop(_l, 1 ); // get rid of package table from top of stack
}
- (void)dofile:(const char *)file
{
	int err=luaL_dofile(_l, file);
    if(err){
        NSLog(@"dofile:%@",[self toNSString:-1]);
    }
}

- (void)getglobal:(const char *)s
{
	lua_getglobal(_l, s);
}

- (void)gettable:(int)idx{
    lua_gettable(_l, idx);
}
- (void)lregister:(const char*)name func:(lua_CFunction)fn{
    lua_register(_l, name, fn);
}
- (void)pushnil
{
	lua_pushnil(_l);
}

- (void)pushnumber:(lua_Number)n
{
	lua_pushnumber(_l, n);
}

- (void)pushinteger:(lua_Integer)i
{
	lua_pushinteger(_l, i);
}

- (void)pushlstring:(const char *)s len:(size_t)len
{
	lua_pushlstring(_l, s, len);
}

- (void)pushstring:(const char *)s
{
	lua_pushstring(_l, s);
}

- (void)pushNSString:(NSString *)s
{
	[self pushlstring:[s UTF8String] len:s.length];
}

- (void)pushboolean:(bool)b
{
	lua_pushboolean(_l, b);
}

- (void)pushcfunction:(void *)func
{
	lua_pushcfunction(_l, func);
}

- (void)settable:(int)idx
{
	lua_settable(_l, idx);
}

- (void)setglobal:(const char *)k
{
	lua_setglobal(_l, k);
}

//
- (int)type:(int)idx{
    return lua_type(_l, idx);
}
- (const char*)tname:(int)tp{
    return lua_typename(_l, tp);
}
- (int)next:(int)idx{
    return lua_next(_l, idx);
}
- (int)istable:(int)idx{
    return lua_istable(_l, idx);
}
- (lua_Number)tonumber:(int)idx
{
	return lua_tonumber(_l, idx);
}

- (lua_Integer)tointeger:(int)idx
{
	return lua_tointeger(_l, idx);
}

- (int)toboolean:(int)idx
{
	return lua_toboolean(_l, idx);
}

- (const char *)tolstring:(int)idx len:(size_t *)len
{
	return lua_tolstring(_l, idx, len);
}

- (NSString *)toNSString:(int)idx
{
	return [NSLua toNSString:idx lstate:_l];
}

+ (NSString *)toNSString:(int)idx lstate:(lua_State*)l{
    size_t		len;
	const char	*data = lua_tolstring(l, idx, &len);
	return [[[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding] autorelease];
}
//- (size_t)objlen:(int)idx
//{
//	return lua_objlen(_l, idx);
//}

- (lua_State *)tothread:(int)idx
{
	return lua_tothread(_l, idx);
}

- (const void *)topointer:(int)idx
{
	return lua_topointer(_l, idx);
}
- (NSDictionary*)totable{
    return [NSLua totable:_l];
}
+ (NSDictionary*)totable:(lua_State*)l{
    NSMutableDictionary* t=[NSMutableDictionary dictionary];
    if(!lua_istable(l, -1)){
        return nil;
    }
    lua_pushnil(l);
    while (lua_next(l, -2) != 0) {
        NSString *key=[NSLua toNSString:-2 lstate:l];
        switch (lua_type(l, -1)) {
            case LUA_TNUMBER:{
                NSObject *val=[NSNumber numberWithDouble:lua_tonumber(l, -1)];
                [t setObject:val forKey:key];
            }
                break;
            case LUA_TBOOLEAN:{
                NSObject *val=[NSNumber numberWithDouble:lua_toboolean(l,-1)];
                [t setObject:val forKey:key];
            }
                break;
            default:{
                NSObject *val=[NSLua toNSString:-1 lstate:l];
                [t setObject:val forKey:key];
            }
                break;
        }
        lua_pop(l, 1);
    }
    return t;
}
- (void)call:(int)nargs nrs:(int)nresults
{
	lua_call(_l, nargs, nresults);
}

- (void)pcall:(int)nargs nrs:(int)nresults
{
	lua_pcall(_l, nargs, nresults, 0);
}

- (void)pop:(int)n
{
	lua_pop(_l, n);
}

- (void)dealloc
{
	lua_close(_l);
	[super dealloc];
}

@end
