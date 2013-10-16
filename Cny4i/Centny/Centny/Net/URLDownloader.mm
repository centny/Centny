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
@property(nonatomic) NSOutputStream *outs;
@property(nonatomic) NSMutableData	*buf;
@property(nonatomic) NSDate			*begin;
@property(nonatomic) long			tfed;
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
		self.tfed		= 0;
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
		NSMutableDictionary *rg = [NSMutableDictionary dictionary];
		[rg setObject:[NSString stringWithFormat:@"%ld", tlength] forKey:@"RANGE"];
		[rg setObject:self.url forKey:@"URL"];
		[rg writeToFile:self.tpath atomically:YES];
	}
}

- (float)speed
{
	if (self.begin == nil) {
		return 0;
	} else {
		double time = [[NSDate date]timeIntervalSince1970] - [self.begin timeIntervalSince1970];
		double kb = ((double)self.tfed) / 1024;
		return kb / time;
	}
}

- (NSString *)sptext
{
	float sp = self.speed;
	if (sp >= 1000) {
		return [NSString stringWithFormat:@"%.1fMB", sp / 1024];
	} else {
		return [NSString stringWithFormat:@"%dKB", (int)sp];
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
		self.clength = atol([cl UTF8String]) + self.tlength;
	} else {
		self.clength = 0;
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.buf appendData:data];
	self.tfed += data.length;

	if (self.buf.length < self.bsize) {
		return;
	}

	[self storeBuf];

	if (self.delegate && [self.delegate respondsToSelector:@selector(onDownloaderReceive:received:total:)]) {
		[self.delegate onDownloaderReceive:self received:self.tlength total:self.clength];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	self.tfed	= 0;
	self.begin	= nil;
	[self storeBuf];
	[[NSFileManager defaultManager] removeItemAtPath:self.tpath error:nil];
	[self delTStream];
	[self freeStream];
	[super connectionDidFinishLoading:connection];
	NSDLog(@"down file success to:%@", self.spath);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.tfed	= 0;
	self.begin	= nil;
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
	self.tfed	= 0;
	self.begin	= [NSDate date];
	[self start];
	NSDLog(@"start down file(Range:%ld) to:%@", self.tlength, self.spath);
}

- (long)readTlenth
{
	NSDictionary *rg = [NSDictionary dictionaryWithContentsOfFile:self.tpath];

	if (rg == nil) {
		return 0;
	}

	if (![self.url isEqualToString:[rg objectForKey:@"URL"]]) {
		return 0;
	}

	NSString *ltext = [rg objectForKey:@"RANGE"];

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

