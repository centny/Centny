//
//  URLDownloader.h
//  ALearning
//
//  Created by Cny on 10/6/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "URLRequester.h"
//
#define DEFAULT_DL_BSIZE 4096
@class URLDownloader;
//
@protocol URLDownloaderDelegate <URLRequesterDelegate>
@optional
- (void)onDownloaderReceive:(URLDownloader *)downloader received:(long)r total:(long)t;
@end
//
@interface URLDownloader : URLRequester
@property(nonatomic, readonly) NSString *spath;		// file save path.
@property(nonatomic, readonly) NSString *tpath;		// tmp save path.
@property(nonatomic, readonly) float	trate;		// transftered rate.
@property(nonatomic, readonly) BOOL		proceed;	// default is YES.
@property(nonatomic) long				clength;	// content length.
@property(nonatomic) long				tlength;	// transftered length.
@property(nonatomic) long				bsize;		// the block size.
// @property(nonatomic, readonly) NSOutputStream			*output;
@property(nonatomic, assign) id <URLDownloaderDelegate> delegate;
//
- (void)down;
//
+ (id)downWith:(NSString *)url spath:(NSString *)spath completed:(URLReqCompleted)finished;
+ (id)downProceedWith:(NSString *)url spath:(NSString *)spath completed:(URLReqCompleted)finished;
@end

