//
//  URLDownloader.m
//  ALearning
//
//  Created by Cny on 10/6/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "URLDownloader.h"
#import "ClassExt.h"
#include <fstream>
#include <iostream>
#include <sstream>
//
#define OUTS_FLAGS	0x01 | 0x04
#define TMPS_FLAGS	0x01 | 0x08
using namespace std;
//
@interface URLDownloader ()
// @property(nonatomic) fstream *outs;
@property(nonatomic) NSOutputStream *outs;
// @property(nonatomic) fstream		*tmps;
@property(nonatomic) NSMutableData *buf;
// @property(nonatomic) char			*cbuf;
@end
@implementation URLDownloader
+ (id)downWith:(NSString *)url spath:(NSString *)spath completed:(URLReqCompleted)finished
{
	URLDownloader *dl = [[URLDownloader alloc]init];

	dl.url			= url;
	dl.method		= @"GET";
	dl.completed	= finished;
	dl->_spath		= spath;
	dl->_proceed	= NO;
	return dl;
}

+ (id)downProceedWith:(NSString *)url spath:(NSString *)spath completed:(URLReqCompleted)finished
{
	URLDownloader *dl = [[URLDownloader alloc]init];

	dl.url			= url;
	dl.method		= @"GET";
	dl.completed	= finished;
	dl->_spath		= spath;
	dl->_tpath		= [spath stringByAppendingString:@".tmp"];
	dl->_proceed	= YES;
	return dl;
}

- (id)init
{
	self = [super init];

	if (self) {
		self.buf		= [NSMutableData data];
		self.bsize		= DEFAULT_DL_BSIZE;
		self.clength	= self.tlength = 0;
		_proceed		= YES;
	}

	return self;
}

- (float)trate
{
	if (self.clength < 1) {
		return 0;
	} else {
		return ((double)self.tlength) / ((double)self.clength);
	}
}

- (void)setTlength:(long)tlength
{
	_tlength = tlength;

	if (self.proceed) {
		[[NSString stringWithFormat:@"%ld", tlength]writeToFile:self.tpath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	}
}

- (void)storeBuf
{
	if (self.buf.length < 1) {
		return;
	}

	[self.outs write:(const uint8_t *)self.buf.bytes maxLength:self.buf.length];
	self.tlength	+= self.buf.length;
	self.buf.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[super connection:connection didReceiveResponse:response];
	NSDLog(@"Reponse status code:%d", [self statusCode]);
	switch ([self statusCode]) {
		case 206:
			self.outs = [[NSOutputStream alloc]initToFileAtPath:self.spath append:YES];
			[self.outs open];
			break;

		case 200:
			self.outs = [[NSOutputStream alloc]initToFileAtPath:self.spath append:NO];
			[self.outs open];
			_proceed = NO;
			[self delTStream];
			break;

		default:
			[self cancel];
			return;
	}
	NSString *cl = [self.res_h objectForKey:@"Content-Length"];

	if (cl && cl.length) {
		self.clength = atol([cl UTF8String]);
	} else {
		self.clength = 0;
	}

	if (self.clength && self.dldelegate && [self.dldelegate respondsToSelector:@selector(onDownloaderRate:trate:)]) {
		[self.dldelegate onDownloaderRate:self trate:self.trate];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.buf appendData:data];

	if (self.buf.length < self.bsize) {
		return;
	}

	[self storeBuf];

	if (self.dldelegate && [self.dldelegate respondsToSelector:@selector(onDownloaderReceive:received:total:)]) {
		[self.dldelegate onDownloaderReceive:self received:self.tlength total:self.clength];
	}

	if (self.clength && self.dldelegate && [self.dldelegate respondsToSelector:@selector(onDownloaderRate:trate:)]) {
		[self.dldelegate onDownloaderRate:self trate:self.trate];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[self storeBuf];
	[[NSFileManager defaultManager] removeItemAtPath:self.tpath error:nil];
	[self delTStream];
	[self freeStream];
	[super connectionDidFinishLoading:connection];
	NSDLog(@"down file success to:%@", self.spath);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self freeStream];
	[super connection:connection didFailWithError:error];
	NSDLog(@"down file error to:%@", self.spath);
}

- (void)down
{
	if ((self.spath == nil) || [self.spath isEmptyOrWhiteSpace]) {
		if (self.completed) {
			self.completed(self, @"save path not setting.");
		}

		return;
	}

	_tlength = [self readTlenth];
	[self addHeaderField:@"Range" value:[NSString stringWithFormat:@"bytes=%ld-", self.tlength]];
	//
	NSDLog(@"start down file(Range:%ld) to:%@", self.tlength, self.spath);

	[self start];
}

- (long)readTlenth
{
	NSString *ltext = [NSString stringWithContentsOfFile:self.tpath encoding:NSUTF8StringEncoding error:nil];

	if (ltext) {
		return atol([ltext UTF8String]);
	} else {
		return 0;
	}
}

- (void)freeStream
{
	if (self.outs) {
		[self.outs close];
		self.outs = NULL;
	}
}

- (void)delTStream
{
	[[NSFileManager defaultManager]removeItemAtPath:self.tpath error:nil];
}

- (void)dealloc
{
	[self freeStream];
}

@end

