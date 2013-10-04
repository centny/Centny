//
//  NSNetLua.m
//  NSLua
//
//  Created by Cny on 10/4/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "NSNetLua.h"
#import "URLRequester.h"
#import "ClassExt.h"
//
NSMutableDictionary* __bmaps=nil;

int lHttpBack(lua_State* l){
    NSString* cback=[NSLua toNSString:-1 lstate:l];
    lua_pop(l, 1);
    NSString* msg=[NSLua toNSString:-1 lstate:l];
    lua_pop(l, 1);
    NSString* sdata=[NSLua toNSString:-1 lstate:l];
    lua_pop(l, 1);
    NetLuaCompleted finish=[[NSNetLua sharedBmaps]objectForKey:cback];
    finish(sdata,msg);
    [[NSNetLua sharedBmaps]removeObjectForKey:cback];
    return 1;
}
int lGetHttp(lua_State* l){
    NSString* cback=[NSLua toNSString:-1 lstate:l];
    lua_pop(l, 1);
    NSString* mback=[NSLua toNSString:-1 lstate:l];
    lua_pop(l, 1);
    NSDictionary* args=[NSLua totable:l];
    lua_pop(l, 1);
    NSString* url=[NSLua toNSString:-1 lstate:l];
    lua_pop(l, 1);
    NSString* rurl=nil;
    if(args.count){
        rurl=[NSString stringWithFormat:@"%@?%@",url,[args stringByURLQuery]];
    }else{
        rurl=url;
    }
    [[[URLRequester alloc]initGetURL:rurl completed:^(URLRequester *req, NSObject *msg) {
        lua_getglobal(l, [mback UTF8String]);
        if(msg){
            lua_pushstring(l, [[NSString stringWithFormat:@"%@",msg]UTF8String]);
            lua_pushnil(l);
            lua_pushstring(l, [cback UTF8String]);
        }else{
            lua_pushnil(l);
            lua_pushstring(l, [req.sdata UTF8String]);
            lua_pushstring(l, [cback UTF8String]);
        }
        lua_call(l, 3, 0);
    }]start];
    return 1;
}
@implementation NSNetLua
-(id)initWithFile:(const char *)file{
    self=[super initWithFile:file];
    if(self){
        [self lregister:"HGet" func:lGetHttp];
        [self lregister:"HTTPBack" func:lHttpBack];
    }
    return self;
}
- (void)call:(int)nargs nrs:(int)nresults completed:(NetLuaCompleted)finish{
    if(finish){
        NSString* key=[NSString stringWithFormat:@"%@",finish];
        [[NSNetLua sharedBmaps]setObject:finish forKey:key];
        [self pushNSString:key];
        nargs++;
    }else{
        [self pushnil];
    }
    [super call:nargs nrs:nresults];
}
+(NSMutableDictionary*)sharedBmaps{
    if(__bmaps==nil){
        __bmaps=[NSMutableDictionary dictionary];
    }
    return __bmaps;
}
@end
