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
@interface URLRequester ()
@property(nonatomic) NSMutableURLRequest	*request;
@property(nonatomic) NSURLConnection		*connection;
@end

@implementation URLRequester
- (id)init
{
	self = [super init];

	if (self) {
		self.encoding	= NSUTF8StringEncoding;
		self.method		= @"GET";
		_timeout		= URL_TIME_OUT;
		_res_d			= [NSMutableData data];
		_args			= [NSMutableDictionary dictionary];
		_req_h			= [NSMutableDictionary dictionary];
		_res_h			= [NSMutableDictionary dictionary];
	}

	return self;
}

- (NSString *)sdata
{
	if (self.res_d && self.res_d.length) {
		return [[NSString alloc] initWithData:self.res_d encoding:self.encoding];
	} else {
		return @"";
	}
}

- (NSInteger)statusCode
{
	return self.response.statusCode;
}

- (void)addURLArgs:(NSString *)args
{
	[self.args addEntriesFromDictionary:[args dictionaryByURLQuery]];
}

- (void)addDictArgs:(NSDictionary *)dict
{
	[self.args addEntriesFromDictionary:dict];
}

- (void)addArgBy:(NSString *)key value:(NSString *)value
{
	[self.args setObject:value forKey:key];
}

- (void)addHeaderField:(NSString *)key value:(NSString *)value
{
	[self.req_h setObject:value forKey:key];
}

- (NSString *)codingData:(NSStringEncoding)coding
{
	if (self.res_d) {
		return [[NSString alloc] initWithData:self.res_d encoding:coding];
	} else {
		return @"";
	}
}

- (void)start
{
	if ([@"GET" isEqualToString : self.method]) {
		if (self.args.count) {
			NSRange rg = [self.url rangeOfString:@"?"];

			if (rg.length < 1) {
				self.url = [NSString stringWithFormat:@"%@?%@", self.url, [self.args stringByURLQuery]];
			} else {
				if (rg.location < self.url.length - 1) {
					self.url = [NSString stringWithFormat:@"%@&%@", self.url, [self.args stringByURLQuery]];
				} else {
					self.url = [NSString stringWithFormat:@"%@%@", self.url, [self.args stringByURLQuery]];
				}
			}
		}

		self.request = [self createRequest:self.url method:self.method];
		NSDLog(@"GET %@", self.url);
	} else {
		NSRange rg = [self.url rangeOfString:@"?"];

		if (rg.length) {
			NSString *query = [self.url substringFromIndex:rg.location + 1];
			self.url = [self.url substringToIndex:rg.location];
			[self addURLArgs:query];
		}

		self.request = [self createRequest:self.url method:self.method];
		NSString *query = [self.args stringByURLQuery];
		NSDLog(@"POST %@,%@", self.url, query);
		[self.request setHTTPBody:[[self.req_h stringByURLQuery]dataUsingEncoding:self.encoding]];

		if (self.setting_r) {
			self.setting_r(self, self.request);
		}
	}

	for (NSString *key in [self.req_h allKeys]) {
		[self.request setValue:[self.req_h objectForKey:key] forHTTPHeaderField:key];
	}

	self.connection = [[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:YES];
}

- (void)cancel
{
	[self.connection cancel];
}

- (NSMutableURLRequest *)createRequest:(NSString *)url method:(NSString *)method
{
	NSURL				*URL;
	NSMutableURLRequest *request;

	URL		= [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:self.timeout];

	[request setHTTPMethod:method];
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	_response = (NSHTTPURLResponse *)response;
	[((NSMutableDictionary *)self.res_h)addEntriesFromDictionary :[self.response allHeaderFields]];
	[[NSNotificationCenter defaultCenter] postNotificationName:NO_NETWORK_NOTICE object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.response, @"response", self, @"requester", @"response", @"type", nil]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[((NSMutableData *)self.res_d)appendData : data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(onRequestCompleted:success:)]) {
		[self.delegate onRequestCompleted:self success:nil];
	}

	if (self.completed) {
		self.completed(self, nil);
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:NO_NETWORK_NOTICE object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.response, @"response", self, @"requester", @"finish", @"type", nil]];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[[NSNotificationCenter defaultCenter] postNotificationName:NO_NETWORK_NOTICE object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error, @"error", self, @"requester", @"error", @"type", nil]];

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

//////

+ (void)doGet:(NSString *)url
{
	[self doGet:url completed:nil];
}

+ (void)doGet:(NSString *)url completed:(URLReqCompleted)finished
{
	URLRequester *req = [[URLRequester alloc]init];

	req.url			= url;
	req.method		= @"GET";
	req.completed	= finished;
	[req start];
}

+ (void)doPost:(NSString *)url
{
	[self doPost:url completed:nil];
}

+ (void)doPost:(NSString *)url args:(NSString *)args
{
	[self doPost:url args:args completed:nil];
}

+ (void)doPost:(NSString *)url dict:(NSDictionary *)dict
{
	[self doPost:url dict:dict completed:nil];
}

+ (void)doPost:(NSString *)url completed:(URLReqCompleted)finished
{
	URLRequester *req = [[URLRequester alloc]init];

	req.url			= url;
	req.method		= @"POST";
	req.completed	= finished;
	[req start];
}

+ (void)doPost:(NSString *)url args:(NSString *)args completed:(URLReqCompleted)finished
{
	URLRequester *req = [[URLRequester alloc]init];

	req.url		= url;
	req.method	= @"POST";
	[req addURLArgs:args];
	req.completed = finished;
	[req start];
}

+ (void)doPost:(NSString *)url dict:(NSDictionary *)dict completed:(URLReqCompleted)finished
{
	URLRequester *req = [[URLRequester alloc]init];

	req.url		= url;
	req.method	= @"POST";
	[req addDictArgs:dict];
	req.completed = finished;
	[req start];
}

+ (void)doPost:(NSString *)url dict:(NSDictionary *)dict sreq:(URLReqSetRequest)sreq completed:(URLReqCompleted)finished
{
	URLRequester *req = [[URLRequester alloc]init];

	req.url		= url;
	req.method	= @"POST";
	[req addDictArgs:dict];
	req.setting_r	= sreq;
	req.completed	= finished;
	[req start];
}

@end

