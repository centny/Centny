//
//  NSPart.m
//  Centny
//
//  Created by Centny on 9/12/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "NSPart.h"
#import "../Core/CoreMethod.h"
@implementation NSPart
@synthesize one = _one, two = _two;
- (id)initWith:(id)one two:(id)two
{
	self = [super init];

	if (self) {
		self.one	= one;
		self.two	= two;
	}

	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	return [[NSPart alloc]initWith:_one two:_two];
}

+ (id)partWith:(id)one two:(id)two
{
	return [[[NSPart alloc]initWith:one two:two]autorelease];
}

+ (id)partWithPart:(NSPart *)part
{
	return [[[NSPart alloc]initWith:part.one two:part.two]autorelease];
}

+ (id)stringPartWith:(NSString *)data separator:(NSString *)sep
{
	NSArray *ary = [data componentsSeparatedByString:sep];

	if ([ary count] < 2) {
		NSDLog(@"warning:find less than 2 components by separator(%@) to string(%@)", sep, data);
		return nil;
	}

	if ([ary count] > 2) {
		NSDLog(@"warning:find more than 2 components by separator(%@) to string(%@)", sep, data);
	}

	return [NSPart partWith:ary[0] two:ary[1]];
}

- (BOOL)numberInPart:(NSNumber *)num
{
	return ((_one == nil) || ([num compare:_one] > NSOrderedAscending)) && ((_two == nil) || ([num compare:_two] < NSOrderedDescending));
}

+ (id)numberPartWith:(NSString *)data separator:(NSString *)sep
{
	NSArray *ary = [data componentsSeparatedByString:sep];

	if ([ary count] < 2) {
		NSDLog(@"warning:find less than 2 components by separator(%@) to string(%@)", sep, data);
		return nil;
	}

	if ([ary count] > 2) {
		NSDLog(@"warning:find more than 2 components by separator(%@) to string(%@)", sep, data);
	}

	NSNumber *_onum = nil, *_tnum = nil;

	if ([ary[0] length] > 0) {
		_onum = [NSNumber numberWithFloat:[ary[0] floatValue]];
	}

	if ([ary[1] length] > 0) {
		_tnum = [NSNumber numberWithFloat:[ary[1] floatValue]];
	}

	return [NSPart partWith:_onum two:_tnum];
}

@end
