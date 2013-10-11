//
//  UIRefreshViewDelegate.h
//  Centny
//  the Refresh View Delegate declaration.
//  Created by Centny on 9/20/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
// the refresh view status.
typedef enum RefreshViewStatus {
	RVS_NORMAL = 1,	// the general status;
	RVS_CAN_REL,	// can release handle.
	RVS_REFRESHING	// refreshing.
} RefreshViewStatus;

// the proposal height for refresh view.
#define REFRESH_SCROLL_H 60
//
// the delegate for the refresh view.
@protocol UIRefreshViewDelegate <NSObject>
@required
// callback when user can release their handle.
- (void)onCanRelHand:(UIView *)target;
// callback when user release their handle.
- (void)onRelHandle:(UIView *)target;
// callback when the refresh action completed.
- (void)onDidRefresh:(UIView *)target;
@end
