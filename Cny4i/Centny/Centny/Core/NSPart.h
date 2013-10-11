//
//  NSPart.h
//  Centny
//
//  Created by Centny on 9/12/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPart : NSObject <NSCopying>{
	id _one, _two;
}
@property(nonatomic, retain) id one;
@property(nonatomic, retain) id two;
- (id)initWith:(id)one two:(id)two;
+ (id)partWith:(id)one two:(id)two;
+ (id)partWithPart:(NSPart *)part;
// create the part object with separating string.
+ (id)stringPartWith:(NSString *)data separator:(NSString *)sep;
//////////////////////////
/////the number part//////
// one is nil meaning infinitesimal,two is nul meaning infinity.
- (BOOL)numberInPart:(NSNumber *)num;
// initial number part by stirng ,eg:1-2,-2,100-
+ (id)numberPartWith:(NSString *)data separator:(NSString *)sep;
//////////////////////////
@end
