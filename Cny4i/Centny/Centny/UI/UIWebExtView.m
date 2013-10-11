//
//  UIWebExtView.m
//  Centny
//
//  Created by Centny on 9/20/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "UIWebExtView.h"
#import "../GeneralDef.h"
#import "UIRefreshView.h"
#import "../ClassExt/ClassExt.h"
#import "NSRefreshProxy.h"
@interface UIWebExtView () {
	NSString			*_url;		// the targt URL.
	BOOL				isReload;	// if reload.
	NSMutableDictionary *_ajaxURL;	// the Ajax request URL map by ID.
	NSRefreshProxy		*_rproxy;	// the refresh proxy.
}
@end
//
@implementation UIWebExtView
@synthesize rdelegate = _rdelegate, wdelegate = _wdelegate, isOpenAjaxHandler = _isOpenAjaxHandler, refreshView = _refreshView;
- (id)initWithFrame:(CGRect)frame
{
	UIRefreshView *rv = [[[UIRefreshView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, REFRESH_SCROLL_H) style:RVS_C_W] autorelease];

	self			= [self initWithFrame:frame refreshView:rv];
	self.rdelegate	= rv;
	return self;
}

- (id)initWithFrame:(CGRect)frame refreshView:(UIView *)refreshView
{
	self = [super initWithFrame:frame];

	if (self) {
		_refreshView		= [refreshView retain];
		_refreshView.frame	= CGRectMake(0, -FRAM_H(_refreshView), FRAM_W(_refreshView), FRAM_H(_refreshView));
		UIScrollView *scrollView = [[self subviews] lastObject];
		[scrollView insertSubview:_refreshView atIndex:1];
		self.delegate			= self;
		isReload				= NO;
		_ajaxURL				= [[NSMutableDictionary alloc] init];
		_isOpenAjaxHandler		= NO;
		_rproxy					= [[NSRefreshProxy alloc] init];
		_rproxy.refreshDragDis	= FRAM_H(_refreshView);
	}

	return self;
}

- (void)setRdelegate:(id <UIRefreshViewDelegate>)rdelegate
{
	_rdelegate			= rdelegate;
	_rproxy.rdelegate	= _rdelegate;
}

- (void)setDelegate:(id <UIWebViewDelegate>)delegate
{
	super.delegate = self;
}

- (void)loadURL:(NSString *)url
{
	IF_REL(_url);
	_url = [url retain];
	[self loadRequest:URL_REQUEST(_url)];
}

- (BOOL)isNeedRefresh
{
	if ([_wdelegate respondsToSelector:@selector(isRefresh:)]) {
		return [_wdelegate isRefresh:self];
	} else {
		return ![self isLoading];
	}
}

- (void)processAjaxHandler:(NSURL *)url
{
	NSString	*host	= url.host;
	NSString	*path	= url.path;

	if ([@"open" isEqualToString : host]) {
		NSArray *_paths = [path componentsSeparatedByString:@"/"];

		if ([_paths count] != 4) {
			return;
		}

		[_ajaxURL setObject:url.query forKey:_paths[1]];

		if ([_wdelegate respondsToSelector:@selector(onAjaxOpen:method:url:async:)]) {
			[_wdelegate onAjaxOpen:self method:_paths[2] url:url.query async:[@"1" isEqualToString : _paths[3]]];
		}

		NetworkActivityIndicatorVisible(YES);
		return;
	}

	if ([@"send" isEqualToString : host]) {
		if ([_wdelegate respondsToSelector:@selector(onAjaxSend:url:parameters:)]) {
			NSString		*_urlStr	= [_ajaxURL objectForKey:path];
			NSDictionary	*_pars		= [url.query dictionaryByURLQuery];
			[_wdelegate onAjaxSend:self url:_urlStr parameters:_pars];
		}

		NetworkActivityIndicatorVisible(YES);
		return;
	}

	if ([@"back" isEqualToString : host]) {
		if ([_wdelegate respondsToSelector:@selector(onAjaxBack:url:status:data:)]) {
			NSArray *_paths = [path componentsSeparatedByString:@"/"];

			if ([_paths count] != 3) {
				return;
			}

			NSString *_urlStr = [_ajaxURL objectForKey:_paths[1]];
			[_wdelegate onAjaxBack:self url:_urlStr status:[_paths[2] intValue] data:url.query];
		}

		NetworkActivityIndicatorVisible(NO);
	}
}

// ////////////////////////////////////////////////////////////////////////////////////////////
// ////////////////////////////////call back method////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_rproxy scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_rproxy scrollViewDidEndDragging:scrollView isNeedRefresh:^{
		return [self isNeedRefresh];
	} onRefresh:^{
		if ([_wdelegate respondsToSelector:@selector(onRefresh:)]) {
			[_wdelegate onRefresh:self];
		} else {
			[self reload];
		}
	}];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (_isOpenAjaxHandler && [@"ajaxhandler" isEqualToString : request.URL.scheme]) {
		[self processAjaxHandler:request.URL];
		return NO;
	}

	if ([_wdelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
		return [_wdelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
	}

	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	NetworkActivityIndicatorVisible(YES);

	if ([_wdelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
		[_wdelegate webViewDidStartLoad:webView];
	}

	if (_isOpenAjaxHandler && !isReload) {
		NSError *error = nil;
		[webView stringByEvaluatingJavaScriptFromString:FILE_STRING_E(@"UIWebExtView", @"dat", error)];
		IF_E(error, NSDLog(@"%@", [error debugDescription]));
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	if (_isOpenAjaxHandler && isReload) {
		NSError *error = nil;
		[webView stringByEvaluatingJavaScriptFromString:FILE_STRING_E(@"UIWebExtView", @"dat", error)];
		IF_E(error, NSDLog(@"%@", [error debugDescription]));
	} else {
		isReload = YES;
	}

	NetworkActivityIndicatorVisible(NO);

	if ([_wdelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
		[_wdelegate webViewDidFinishLoad:webView];
	}

	UIScrollView *scrollView = [[self subviews] lastObject];
	[_rproxy refreshCompleted:scrollView finished:0];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NetworkActivityIndicatorVisible(NO);

	if ([_wdelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
		[_wdelegate webView:webView didFailLoadWithError:error];
	}

	if ([_rdelegate respondsToSelector:@selector(onDidRefresh:)]) {
		[_rdelegate onDidRefresh:webView];
	}

	UIScrollView *scrollView = [[self subviews] lastObject];
	[_rproxy refreshCompleted:scrollView finished:0];
	NSDLog(@"load URL faild:%@,error:%@", _url, [error debugDescription]);
}

- (void)stopLoading
{
	NetworkActivityIndicatorVisible(NO);
	[super stopLoading];
}

- (void)reload
{
	if ([_wdelegate respondsToSelector:@selector(onReload:)]) {
		if (![_wdelegate onReload:self]) {
			return;
		}
	}

	if (_url) {
		NSRange rg = [_url rangeOfString:@"?"];

		if (rg.length) {
			NSString *_eurl = [_url stringByAppendingFormat:@"&wev_time=%f", [NSDate timeIntervalSinceReferenceDate]];
			[self loadRequest:URL_REQUEST(_eurl)];
		} else {
			NSString *_eurl = [_url stringByAppendingFormat:@"?wev_time=%f", [NSDate timeIntervalSinceReferenceDate]];
			[self loadRequest:URL_REQUEST(_eurl)];
		}
	} else {
		[super reload];
	}
}

- (void)dealloc
{
	IF_REL(_refreshView);
	IF_REL(_url);
	IF_REL(_ajaxURL);
	IF_REL(_rproxy);
	NSRelLog(@"UIWebExtView release...");
	[super dealloc];
}

@end
