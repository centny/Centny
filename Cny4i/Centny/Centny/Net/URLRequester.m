//
//  URLRequester.m
//  NCardSet
//
//  Created by Centny on 4/10/13.
//  Copyright (c) 2013 Centny. All rights reserved.
//

#import "URLRequester.h"
#import "ClassExt.h"

/**
 *    the http requester.
 *    @author Centny
 */
@interface URLRequester () {
	NSMutableDictionary *resHeaders_;
	NSMutableDictionary *reqHeaders_;
	NSMutableData		*data_;
	NSInteger			statusCode_;
	NSMutableURLRequest *request_;
}
@property (nonatomic, copy) URLReqCompleted completed;
- (void)newFields;
// - (NSURLRequest *)createRequest:(NSString *)url method:(NSString *)method dict:(NSDictionary *)dict;
- (NSURLRequest *)createRequest:(NSString *)url method:(NSString *)method;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end

@implementation URLRequester
@synthesize resHeaders = resHeaders_, reqHeaders = reqHeaders_, data = data_, statusCode = statusCode_, delegate, request = request_, sdata;
- (NSString *)sdata
{
	if (self.data) {
		return [[NSString alloc] initWithData:self.data encoding:self.encoding];
	} else {
		return @"";
	}
}

- (id)initGetURL:(NSString *)url
{
	NSLog(@"Get URL:%@", url);
	NSURLRequest *req = [self createRequest:url method:@"GET"];

	self = [super initWithRequest:req delegate:self];

	if (self) {
		[self newFields];
	}

	return self;
}

- (id)initGetURL:(NSString *)url completed:(URLReqCompleted)finished
{
	NSLog(@"Get URL:%@", url);
	NSURLRequest *req = [self createRequest:url method:@"GET"];

	self = [super initWithRequest:req delegate:self];

	if (self) {
		self.completed = finished;
		[self newFields];
	}

	return self;
}

- (id)initPostURL:(NSString *)url
{
	NSURLRequest *req = [self createRequest:url method:@"POST"];

	self = [super initWithRequest:req delegate:self];

	if (self) {
		[self newFields];
	}

	return self;
}

- (id)initPostURL:(NSString *)url args:(NSString *)args
{
	NSURLRequest *req = [self createRequest:url method:@"POST"];

	self = [super initWithRequest:req delegate:self];

	if (self) {
		[self newFields];
		[self.reqHeaders addEntriesFromDictionary:[args dictionaryByURLQuery]];
	}

	return self;
}

- (id)initPostURL:(NSString *)url dict:(NSDictionary *)dict
{
	NSURLRequest *req = [self createRequest:url method:@"POST"];

	self = [super initWithRequest:req delegate:self];

	if (self) {
		[self newFields];
		[self.reqHeaders addEntriesFromDictionary:dict];
	}

	return self;
}

- (id)initPostURL:(NSString *)url completed:(URLReqCompleted)finished
{
	NSURLRequest *req = [self createRequest:url method:@"POST"];

	self = [super initWithRequest:req delegate:self];

	if (self) {
		[self newFields];
		self.completed = finished;
	}

	return self;
}

- (id)initPostURL:(NSString *)url args:(NSString *)args completed:(URLReqCompleted)finished
{
	NSURLRequest *req = [self createRequest:url method:@"POST"];

	self = [super initWithRequest:req delegate:self];

	if (self) {
		[self newFields];
        NSLog(@"%@",[args dictionaryByURLQuery]);
		[self.reqHeaders addEntriesFromDictionary:[args dictionaryByURLQuery]];
        NSLog(@"%@",self.reqHeaders);
		self.completed = finished;
	}

	return self;
}

- (id)initPostURL:(NSString *)url dict:(NSDictionary *)dict completed:(URLReqCompleted)finished
{
	NSURLRequest *req = [self createRequest:url method:@"POST"];

	self = [super initWithRequest:req delegate:self];

	if (self) {
		[self newFields];
		[self.reqHeaders addEntriesFromDictionary:dict];
		self.completed = finished;
	}

	return self;
}

- (void)addArgs:(NSString *)args
{
	[self.reqHeaders addEntriesFromDictionary:[args dictionaryByURLQuery]];
}

- (void)addDict:(NSDictionary *)dict
{
	[self.reqHeaders addEntriesFromDictionary:dict];
}

- (void)addKey:(NSString *)key value:(NSString *)value
{
	[self.reqHeaders setObject:value forKey:key];
}

- (NSString *)codingData:(NSStringEncoding)coding
{
	if (self.data) {
		return [[NSString alloc] initWithData:self.data encoding:coding];
	} else {
		return @"";
	}
}

- (void)start
{
	if (self.reqHeaders && self.reqHeaders.count) {
		[self.request setHTTPBody:[[self.reqHeaders stringByURLQuery] dataUsingEncoding:NSUTF8StringEncoding]];
	}

	[super start];
}

- (void)newFields
{
	resHeaders_		= [NSMutableDictionary dictionary];
	reqHeaders_		= [NSMutableDictionary dictionary];
	statusCode_		= -1;
	self.encoding	= NSUTF8StringEncoding;
}

- (NSURLRequest *)createRequest:(NSString *)url method:(NSString *)method
{
	NSURL				*URL		= [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *request	= [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:URL_TIME_OUT];

	[request setHTTPMethod:method];
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;

	statusCode_ = res.statusCode;
	[resHeaders_ addEntriesFromDictionary:[res allHeaderFields]];
	data_ = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[data_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(onRequestCompleted:success:)]) {
		[self.delegate onRequestCompleted:self success:nil];
	}

	if (self.completed) {
		self.completed(self, nil);
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[[NSNotificationCenter defaultCenter] postNotificationName:NO_NETWORK_NOTICE object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error, @"error", self, @"requester", nil]];

	if (self.delegate && [self.delegate respondsToSelector:@selector(onRequestCompleted:success:)]) {
		[self.delegate onRequestCompleted:self success:error];
	}

	if (self.completed) {
		self.completed(self, error);
	}
}

- (void)dealloc
{
	self.completed = nil;
}

@end

