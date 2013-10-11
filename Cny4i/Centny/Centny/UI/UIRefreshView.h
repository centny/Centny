//
//  UIRefreshView.h
//  Centny
//  One gengeral Refresh view.
//  Created by Centny on 9/20/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIRefreshViewDelegate.h"
#import "UILineView.h"
// the refresh view implement style.
typedef enum UIRefreshViewStyle {
	RVS_C_B = 1,	// the clear background and black label.
	RVS_C_W,		// the clear background and white label.
	RVS_W_B,		// the white background and black label.
} UIRefreshViewStyle;
// the UIRefreshView.
@interface UIRefreshView : UILineView <UIRefreshViewDelegate>{
	RefreshViewStatus		_state;			// the current refresh view status.
	UILabel					*_info;			// the info label.
	UIActivityIndicatorView *_activity;		// the loading activity.
	UILabel					*_date;			// the date label.
	UIRefreshViewStyle		_style;			// the refresh view style.
}
// init the refresh view by frame and style.
- (id)initWithFrame:(CGRect)frame style:(UIRefreshViewStyle)style;
//
@property(nonatomic, assign) RefreshViewStatus			state;
@property(nonatomic, assign) UIRefreshViewStyle			style;
@property(nonatomic, readonly) UILabel					*info;
@property(nonatomic, readonly) UIActivityIndicatorView	*activity;
@property(nonatomic, readonly) UILabel					*date;
@end
