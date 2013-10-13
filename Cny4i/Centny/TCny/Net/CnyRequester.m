//
//  CnyRequester.m
//  TCny
//
//  Created by Cny on 10/13/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "CnyRequester.h"

@implementation CnyRequester
+ (void)test
{
#if T_REQUEST
//		[self testGetRequest];
//		[self testGetRequest2];
//        [self testPostRequest];
#endif
}

+ (void)testGetRequest
{
	[URLRequester doGet:@"http://www.baidu.com" completed:^(URLRequester *req, NSObject *msg) {
		NSDLog(@"%@,%d,%d", @"GET-1", req.statusCode, req.res_d.length);
	}];
	[URLRequester doGet:@"http://www.baidu.com?ab=1" completed:^(URLRequester *req, NSObject *msg) {
		NSDLog(@"%@,%d,%d", @"GET-2", req.statusCode, req.res_d.length);
	}];
	[URLRequester doGet:@"http://www.baidu.com?ab=1&bc=1ss" completed:^(URLRequester *req, NSObject *msg) {
		NSDLog(@"%@,%d,%d", @"GET-3", req.statusCode, req.res_d.length);
	}];
}

+ (void)testGetRequest2
{
	URLRequester *req = [[URLRequester alloc]init];

	req.url		= @"http://www.baidu.com";
	req.method	= @"GET";
	[req addURLArgs:@"ab=1"];
    [req addDictArgs:[NSDictionary dictionaryWithObject:@"dict value" forKey:@"cd"]];
	[req start];
}
+ (void)testPostRequest
{
	[URLRequester doPost:@"http://www.baidu.com" completed:^(URLRequester *req, NSObject *msg) {
		NSDLog(@"%@,%d,%d", @"POST-1", req.statusCode, req.res_d.length);
	}];
	[URLRequester doPost:@"http://www.baidu.com?ab=1" completed:^(URLRequester *req, NSObject *msg) {
		NSDLog(@"%@,%d,%d", @"POST-2", req.statusCode, req.res_d.length);
	}];
	[URLRequester doPost:@"http://www.baidu.com?ab=1&bc=1ss" completed:^(URLRequester *req, NSObject *msg) {
		NSDLog(@"%@,%d,%d", @"POST-3", req.statusCode, req.res_d.length);
	}];
}
@end

