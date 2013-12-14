//
//  CoreMethod.h
//  Centny
//
//  Created by Centny on 9/25/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
// define some core method for log.

FOUNDATION_EXPORT void NSUseDLog(bool use);

FOUNDATION_EXPORT void NSUseRelLog(bool use);

FOUNDATION_EXPORT void NSDLog(NSString *format, ...);

FOUNDATION_EXPORT void NSRelLog(NSString *format, ...);

FOUNDATION_EXPORT void NSWLog(NSString *format, ...);

FOUNDATION_EXPORT void NSELog(NSString *format, ...);

FOUNDATION_EXPORT NSString *DocumentDirectory();


typedef void (^ CommonEvent)(id sender,id data, id msg);

