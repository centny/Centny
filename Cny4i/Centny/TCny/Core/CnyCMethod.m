//
//  CnyCMethod.m
//  TCny
//
//  Created by Cny on 10/13/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "CnyCMethod.h"
@implementation CnyCMethod
+ (void)test {
#if T_CORE
    [CnyCMethod testLog];
#endif
}

+ (void)testLog
{
	NSUseDLog(1);
	NSDLog(@"%@", @"using debug log");
	NSUseDLog(0);
	NSDLog(@"%@", @"disable debug log");
    NSUseRelLog(1);
    NSRelLog(@"%@",@"using release log");
    NSUseRelLog(0);
    NSRelLog(@"%@",@"disable release log");
}

@end

