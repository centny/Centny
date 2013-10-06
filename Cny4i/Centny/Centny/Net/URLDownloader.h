//
//  URLDownloader.h
//  ALearning
//
//  Created by Cny on 10/6/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "URLRequester.h"

@interface URLDownloader : URLRequester
@property(nonatomic)NSString* spath;//file save path.
+(void)showLog:(BOOL)log;
@end
