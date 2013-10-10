//
//  URLDownloader.h
//  ALearning
//
//  Created by Cny on 10/6/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "URLRequester.h"
@class URLDownloader;

@protocol URLDownloaderDelegate<NSObject>
@optional
-(void)onDownloaderReceive:(URLDownloader*)downloader received:(long)r total:(long)t;
-(void)onDownloaderRate:(URLDownloader*)downloader trate:(float)tr;
@end

@interface URLDownloader : URLRequester
@property(nonatomic)NSString* spath;//file save path.
@property(nonatomic)long clength;
@property(nonatomic)long tlength;
@property(nonatomic,readonly)float trate;
@property(nonatomic,assign)id<URLDownloaderDelegate> dldelegate;
+(void)showLog:(BOOL)log;
@end
