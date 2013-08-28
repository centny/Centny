//
//  WebViewVCtl.m
//  Centny
//
//  Created by Centny on 9/20/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "WebViewVCtl.h"

@interface WebViewVCtl (){
    UIWebExtView *_web;
}
@end

@implementation WebViewVCtl
//-(BOOL)isRefresh:(UIWebExtView*)web{
//    return YES;
//}
//-(void)onRefresh:(UIWebExtView*)web{
//    [web reload];
//}
//-(BOOL)onReload:(UIWebExtView*)web{
//    return YES;
//}
//-(void)onAjaxOpen:(UIWebExtView*)web method:(NSString*)method url:(NSString*)url async:(BOOL)async{
//    NSDLog(@"open");
//}
//-(void)onAjaxSend:(UIWebExtView*)web url:(NSString*)url parameters:(NSDictionary*)parameters{
//    NSDLog(@"send:%@",parameters);
//}
//-(void)onAjaxBack:(UIWebExtView*)web url:(NSString*)url status:(int)status data:(NSString*)data{
//    NSDLog(@"back");
//}
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSDLog(@"web-01");
//    return YES;
//}
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    NSDLog(@"web-02");
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSDLog(@"web-03");
//}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    NSDLog(@"web-04");
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _web=[[UIWebExtView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    _web.wdelegate=self;
    _web.isOpenAjaxHandler=YES;
//    [_web loadURL:@"http://sco.dnsdynamic.com/webdav/TmpPrj/tmp.html"];
    [_web loadURL:@"http://a.m.taobao.com/i17106303985.htm"];
    [self.view addSubview:_web];
    IF_REL_X(_web, NSDLog(@"web release..."));
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
