//
//  CnyViewController.m
//  TPrj
//
//  Created by Cny on 10/4/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "CnyViewController.h"
#import "NSNetLua.h"
static int bcall(lua_State* s){
    NSLog(@"args:%d",lua_gettop(s));
    NSLog(@"t:%d",lua_istable(s, -1));
    lua_pushnil(s);
    lua_next(s, -2);
    NSLog(@"%@",[NSLua toNSString:-2 lstate:s]);
//    lua_gettable(s, -1);
//    lua_pushnil(s);
//    NSLog(@"%@",[NSLua totable:-1 lstate:s]);
//    NSLog(@"IOS bcall...");
    return 1;
}

@interface CnyViewController ()
@property(nonatomic)NSNetLua* lua;
@end

@implementation CnyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* lfile=[[NSBundle mainBundle]pathForResource:@"TLuaTable" ofType:@"lua"];
    self.lua=[[NSNetLua alloc]initWithFile:[lfile UTF8String]];
    [self.lua lregister:"bcall" func:bcall];
//    [lua getglobal:"backc"];
    [self.lua getglobal:"thttp"];
    [self.lua call:0 nrs:0 completed:^(NSString *sdata, NSString *msg) {
        NSLog(@"Lua thttp ...:%@",sdata);
    }];
    [self.lua pop:1];
    //
    [self.lua getglobal:"thttp2"];
    [self.lua pushNSString:@"testing..."];
    [self.lua call:1 nrs:0 completed:^(NSString *sdata, NSString *msg) {
        NSLog(@"Lua thttp2 ...:%@",sdata);
    }];
//    NSLog(@"%d",[lua istable:-1]);
//    [lua pushstring:"c"];
//    [lua gettable:-2];
//    NSLog(@"%d",[lua tointeger:-1]);
//    [lua pop:1];
//    [lua pushnil];
//    NSLog(@"%@",[lua totable:-2]);
    [self.lua pop:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
