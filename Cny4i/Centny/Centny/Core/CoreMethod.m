//
//  CoreMethod.m
//  Centny
//
//  Created by Centny on 9/25/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "CoreMethod.h"
BOOL	__useDebugLog	= NO;
BOOL	__useRelLog		= NO;
void NSUseDLog(bool use)
{
	__useDebugLog = use;
}

void NSUseRelLog(bool use)
{
	__useRelLog = use;
}

void NSDLog(NSString *format, ...)
{
	if (__useDebugLog) {
		va_list args;
		va_start(args, format);
		NSLogv([NSString stringWithFormat:@"D %@",format], args);
		va_end(args);
	}
}

void NSRelLog(NSString *format, ...)
{
	if (__useRelLog) {
		va_list args;
		va_start(args, format);
		NSLogv([NSString stringWithFormat:@"R %@",format], args);
		va_end(args);
	}
}

NSString *DocumentDirectory()
{
	NSArray		*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString	*documentsDirectory = [paths objectAtIndex:0];

	return documentsDirectory;
}
