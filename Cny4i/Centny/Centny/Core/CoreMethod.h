//
//  CoreMethod.h
//  Centny
//
//  Created by Centny on 9/25/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
// define some core method for log.
void NSUseDLog(bool use);

void NSUseRelLog(bool use);

void NSDLog(NSString *format, ...);

void NSRelLog(NSString *format, ...);

NSString *DocumentDirectory();
