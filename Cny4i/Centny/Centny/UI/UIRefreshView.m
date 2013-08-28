//
//  UIRefreshView.m
//  Centny
//
//  Created by Centny on 9/20/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "UIRefreshView.h"
#import "../GeneralDef.h"
#import "../Core/CoreMethod.h"
#define REFRESH_INFO_W 130
#define REFRESH_INFO_H 16
#define ACTIVITY_S 18
#define REFRESH_DATE_W 240
#define REFRESH_DATE_H 16
@interface UIRefreshView (){
}
@end

@implementation UIRefreshView
@synthesize state=_state,style=_style,info=_info,activity=_activity,date=_date;
//update the date info label.
-(void)updateDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    _date.text = [NSString stringWithFormat:@"最后刷新: %@", [formatter stringFromDate:[NSDate date]]];
    [formatter release];
}
-(id)initWithFrame:(CGRect)frame style:(UIRefreshViewStyle)style{
    self=[super initWithFrame:frame];
    if(self){
        _info=[[UILabel alloc]initWithFrame:CENTER_RECT_H(self, 10, REFRESH_INFO_W, REFRESH_INFO_H)];
        _info.backgroundColor=[UIColor clearColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED<__IPHONE_6_0
        _info.textAlignment=UITextAlignmentCenter;
#else
        _info.textAlignment=NSTextAlignmentCenter;
#endif
        _info.font=[UIFont systemFontOfSize:REFRESH_INFO_H-1];
        [self addSubview:_info];
        _activity=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(FRAM_XW(_info),10-(ACTIVITY_S-REFRESH_INFO_H)/2, ACTIVITY_S, ACTIVITY_S)];
        [self addSubview:_activity];
        _date=[[UILabel alloc]initWithFrame:CENTER_RECT_H(self, FRAM_YH(_activity)+5, REFRESH_DATE_W, REFRESH_DATE_H)];
        _date.backgroundColor=[UIColor clearColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED<__IPHONE_6_0
        _date.textAlignment=UITextAlignmentCenter;
#else
        _date.textAlignment=NSTextAlignmentCenter;
#endif
        _date.font=[UIFont systemFontOfSize:REFRESH_DATE_H-1];
        [self addSubview:_date];
        [self updateDate];
        self.state=RVS_NORMAL;
        self.style=style;
    }
    return self;
}
-(void)setStyle:(UIRefreshViewStyle)style{
    _style=style;
    switch (style) {
        case RVS_C_B:
            self.backgroundColor=[UIColor clearColor];
            _info.textColor=[UIColor blackColor];
            _date.textColor=[UIColor blackColor];
            _activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
            break;
        case RVS_C_W:
            self.backgroundColor=[UIColor clearColor];
            _info.textColor=[UIColor whiteColor];
            _date.textColor=[UIColor whiteColor];
            _activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
            break;
        case RVS_W_B:
            self.backgroundColor=[UIColor whiteColor];
            _info.textColor=[UIColor blackColor];
            _date.textColor=[UIColor blackColor];
            _activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
            break;
        default:
            break;
    }
}
-(void)setState:(RefreshViewStatus)state{
    _state=state;
    switch (_state) {
        case RVS_NORMAL:
            _info.text=@"下拉可以刷新...";
            break;
        case RVS_CAN_REL:
            _info.text=@"释放可以刷新...";
            break;
        case RVS_REFRESHING:
            _info.text=@"正在刷新中...";
            break;
        default:
            _info.text=@"";
            break;
    }
    NSDLog(@"refresh info:%@",_info.text);
}
//////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////deleagate callback method////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
-(void)onCanRelHand:(UIView *)target{
    if(self.state==RVS_NORMAL){
        self.state=RVS_CAN_REL;
    }
}
-(void)onRelHandle:(UIView *)target{
    self.state=RVS_REFRESHING;
    [_activity startAnimating];
}
-(void)onDidRefresh:(UIView *)target{
    self.state=RVS_NORMAL;
    [_activity stopAnimating];
    [self updateDate];
}
-(void)dealloc{
    IF_REL(_info);
    IF_REL(_activity);
    IF_REL(_date);
    NSRelLog(@"UIRefreshView release...");
    [super dealloc];
}
@end
