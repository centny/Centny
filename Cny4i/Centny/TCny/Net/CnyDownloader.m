//
//  CnyDownloader.m
//  TCny
//
//  Created by Cny on 10/13/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "CnyDownloader.h"

@implementation CnyDownloader
+(void)test{
#if T_DOWNL
    NSUseDLog(1);
    [self testDl];
#endif
}
+(void)testDl{
    [[URLDownloader downProceedWith:@"http://down.51voa.com/201310/cat-scared-copycat-fat-cat-cat-nap.mp3" spath:@"/tmp/t.mp3" completed:^(URLRequester *req, NSObject *msg) {
        
    }]down];
}
@end
