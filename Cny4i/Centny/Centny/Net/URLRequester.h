//
//  URLRequester.h
//  NCardSet
//
//  Created by Centny on 4/10/13.
//  Copyright (c) 2013 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
//
#define URL_TIME_OUT 15
#define NO_NETWORK_NOTICE @"NO_NETWORK"

@class URLRequester;

typedef void (^URLReqCompleted)(URLRequester* req,NSObject* msg);
/**
    the URL request delegate.
	@author Centny
 */
@protocol URLRequesterDelegate<NSObject>
/**
	call back when request end.
	@param req the requester instance.
	@param msg nil is request success,or failed.
 */
-(void)onRequestCompleted:(URLRequester*)req success:(NSObject*)msg;
@end
/**
	the URL requester.
	@author Centny
 */
@interface URLRequester : NSURLConnection<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property(nonatomic,readonly)NSDictionary* resHeaders;
@property(nonatomic,readonly)NSMutableDictionary* reqHeaders;
@property(nonatomic,readonly)NSData* data;
@property(nonatomic,readonly)NSString* sdata;
@property(nonatomic,readonly)NSInteger statusCode;
@property(nonatomic,readonly)NSMutableURLRequest* request;
@property(nonatomic,assign)id<URLRequesterDelegate> delegate;
@property(nonatomic)NSStringEncoding encoding;
-(id)initGetURL:(NSString*)url;
-(id)initGetURL:(NSString*)url completed:(URLReqCompleted)finished;
-(id)initPostURL:(NSString *)url;
-(id)initPostURL:(NSString *)url args:(NSString*)args;
-(id)initPostURL:(NSString *)url dict:(NSDictionary*)dict;
-(id)initPostURL:(NSString *)url completed:(URLReqCompleted)finished;
-(id)initPostURL:(NSString *)url args:(NSString*)args completed:(URLReqCompleted)finished;
-(id)initPostURL:(NSString *)url dict:(NSDictionary*)dict completed:(URLReqCompleted)finished;
-(void)addArgs:(NSString*)args;
-(void)addDict:(NSDictionary*)dict;
-(void)addKey:(NSString*)key value:(NSString*)value;
-(NSString*)codingData:(NSStringEncoding)coding;
-(void)start;
@end
