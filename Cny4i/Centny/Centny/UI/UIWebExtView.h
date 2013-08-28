//
//  UIWebExtView.h
//  Centny
//  This is a system UIWebView extend class.
//  Implementing normal refresh view and Ajax callback handler.
//  You can use it only initial general value(initWithFrame,loadURL),if you want to use the default value.
//  If you want to use other founction,see the note UIWebExtViewDelegate and UIWebExtView declaration.
//  Created by Centny on 9/20/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIRefreshViewDelegate.h"
@class UIWebExtView;

//the UIWebExtViewDelegate declaration.
@protocol UIWebExtViewDelegate<UIWebViewDelegate>
@optional
////////////////////////////////////
/////////normal call back.//////////
////////////////////////////////////
//check if need refresh,return NO will not refresh the webview.
-(BOOL)isRefresh:(UIWebExtView*)web;
//callback method for RefreshView,adding custom refresh method.
//always using UIWebView reload method that is default action.
-(void)onRefresh:(UIWebExtView*)web;
//callback method for reload webview,return NO for unexecuting default reload method.
//always using the same time of onRefresh.
//default action is loading the loadURL's URL with adding the timestame or UIWebView's reload.
-(BOOL)onReload:(UIWebExtView*)web;
////////////////////////////////////
/////////Ajax call back.//////////
////////////////////////////////////
//callback method for Ajax open method.
-(void)onAjaxOpen:(UIWebExtView*)web method:(NSString*)method url:(NSString*)url async:(BOOL)async;
//callback method for Ajax send method.
-(void)onAjaxSend:(UIWebExtView*)web url:(NSString*)url parameters:(NSDictionary*)parameters;
//callback method for Ajax response data.
-(void)onAjaxBack:(UIWebExtView*)web url:(NSString*)url status:(int)status data:(NSString*)data;
@end

@interface UIWebExtView : UIWebView<UIWebViewDelegate>{
    id<UIRefreshViewDelegate> _rdelegate;//the refresh view delegate.
    //
    id<UIWebExtViewDelegate> _wdelegate; //the web view delegate.
    UIView *_refreshView;                //the refresh view.
    BOOL _isOpenAjaxHandler;             //if open ajax call back.
}
@property(nonatomic,assign)id<UIRefreshViewDelegate> rdelegate;
@property(nonatomic,assign)id<UIWebExtViewDelegate> wdelegate;
@property(nonatomic,assign)BOOL isOpenAjaxHandler;
@property(nonatomic,readonly)UIView* refreshView;
//the general initial method,it will using the default UIRefreshView as it refresh view.
-(id)initWithFrame:(CGRect)frame;
//the general initial method with using the custom refresh view
//when using this initial method,you change the curstom refresh view's status change by implementing UIRefreshViewDelegate.
-(id)initWithFrame:(CGRect)frame refreshView:(UIView*)refreshView;
//the load method for URL.
//it will using defalut Timestame reload method.
-(void)loadURL:(NSString*)url;
@end
