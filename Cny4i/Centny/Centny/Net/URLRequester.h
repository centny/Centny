//
//  URLRequester.h
//  NCardSet
//
//  Created by Centny on 4/10/13.
//  Copyright (c) 2013 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
//
#define URL_TIME_OUT		15
#define NO_NETWORK_NOTICE	@"NO_NETWORK"

@class URLRequester;

typedef void (^ URLReqCompleted)(URLRequester *req, NSObject *msg);
typedef void (^ URLReqSetRequest)(URLRequester *req, NSMutableURLRequest *request);

/**
 *    the URL request delegate.
 *    @author Centny
 */
@protocol URLRequesterDelegate <NSObject>

/**
 *    call back when request end.
 *    @param req the requester instance.
 *    @param msg nil is request success,or failed.
 */
- (void)onRequestCompleted:(URLRequester *)req success:(NSObject *)msg;
@end

/**
 *    the URL requester.
 *    @author Centny
 */
@interface URLRequester : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
																//
@property(nonatomic) NSStringEncoding				encoding;	// default is UTF-8.
@property(nonatomic) NSString						*url;		// target URL.
@property(nonatomic) NSString						*method;	// default is GET.
@property(nonatomic) long							timeout;
@property(nonatomic, readonly) NSMutableDictionary	*args;		// request arguments.
@property(nonatomic, readonly) NSMutableDictionary	*req_h;		// request header fields.
//
@property(nonatomic, readonly) NSDictionary			*res_h;		// response header fields.
@property(nonatomic, readonly) NSData				*res_d;		// response data
@property(nonatomic, readonly) NSHTTPURLResponse	*response;	//
@property(nonatomic, readonly) NSString				*sdata;		// response string data by encoding.
@property(nonatomic, readonly) NSInteger			statusCode;
//
@property(nonatomic, assign) id <URLRequesterDelegate>	delegate;
@property (nonatomic, copy) URLReqCompleted				completed;
@property (nonatomic, copy) URLReqSetRequest			setting_r;	// call it before start.
//

//
- (void)addURLArgs:(NSString *)args;
- (void)addDictArgs:(NSDictionary *)dict;
- (void)addArgBy:(NSString *)key value:(NSString *)value;
- (void)addHeaderField:(NSString *)key value:(NSString *)value;
//
- (NSString *)codingData:(NSStringEncoding)coding;
- (void)start;
- (void)cancel;

//
+ (void)doGet:(NSString *)url;
+ (void)doGet:(NSString *)url completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url;
+ (void)doPost:(NSString *)url args:(NSString *)args;
+ (void)doPost:(NSString *)url dict:(NSDictionary *)dict;
+ (void)doPost:(NSString *)url completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url args:(NSString *)args completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url dict:(NSDictionary *)dict completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url dict:(NSDictionary *)dict sreq:(URLReqSetRequest)sreq completed:(URLReqCompleted)finished;
@end

