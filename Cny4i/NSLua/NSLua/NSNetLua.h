//
//  NSNetLua.h
//  NSLua
//
//  Created by Cny on 10/4/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "NSLua.h"

typedef void (^NetLuaCompleted)(NSString* sdata,NSString* msg);

@interface NSNetLua : NSLua
+(NSMutableDictionary*)sharedBmaps;
- (void)call:(int)nargs nrs:(int)nresults completed:(NetLuaCompleted)finish;
@end
