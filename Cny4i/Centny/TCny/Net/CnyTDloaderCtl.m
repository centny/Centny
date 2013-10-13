//
//  CnyTDloaderCtl.m
//  TCny
//
//  Created by Cny on 10/13/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "CnyTDloaderCtl.h"

@interface CnyTDloaderCtl ()
@property(nonatomic) URLDownloader *dloader;
@end

@implementation CnyTDloaderCtl

- (IBAction)clkStart:(id)sender
{
//    [[NSFileManager defaultManager]removeItemAtPath:@"/tmp/t.mp3" error:nil];
	self.dloader = [URLDownloader downProceedWith:@"http://down.51voa.com/201310/cat-scared-copycat-fat-cat-cat-nap.mp3" spath:@"/tmp/t.mp3" completed:^(URLRequester *req, NSObject *msg) {}];
    [self.dloader down];
//    NSURL				*URL		= [NSURL URLWithString:[@"http://cny.dnsd.me/wdav/Tmp/1.ape" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//	NSMutableURLRequest *request	= [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
//    
//	[request setHTTPMethod:@"GET"];
//    [[NSURLConnection connectionWithRequest:request delegate:self]start];
}

- (IBAction)clkStop:(id)sender
{
	[self.dloader cancel];
}
- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes{
//    NSLog(@"........");
}
- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL{
    NSLog(@"%@",destinationURL);
    NSError* err;
    [[NSFileManager defaultManager]moveItemAtURL:destinationURL toURL:[NSURL URLWithString:@"file:///tmp/t.apkk"] error:&err];
    NSLog(@"%@",err);
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end

