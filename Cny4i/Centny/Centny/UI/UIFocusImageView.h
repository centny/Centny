//
//  UIFocusImageView.h
//  FFS_Framework
//
//  Created by ShaoHong Wen on 7/6/12.
//  Copyright (c) 2012 fengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
// @protocol PageControlCustomDelegate<NSObject>
//
// @end
//
@protocol UIFocusImageViewDelegate <NSObject>
- (void)didScroll:(NSInteger)idx;
@end
@interface UIFocusImageView : UIView <UIScrollViewDelegate>{
	NSInteger						_currentPage;
	BOOL							_limitScroll;
	NSArray							*_subviews;
	UIScrollView					*scroll;
	UIPageControl					*page;
	CGSize							ssize;
	NSInteger						_pageIdx;
	id <UIFocusImageViewDelegate>	_delegate;
}
- (id)initWithFrame:(CGRect)frame pc:(UIPageControl *)pc views:(NSArray *)views;
- (id)initWithFrame:(CGRect)frame page:(Class)pclass views:(NSArray *)views;
@property(nonatomic, assign, setter = setCurrentPage:) NSInteger	currentPage;
@property(nonatomic, assign, setter = setPageIdx:) NSInteger		pageIdx;
@property(nonatomic, assign) BOOL									limitScroll;
@property(nonatomic, readonly) UIScrollView							*scroll;
@property(nonatomic, readonly) UIPageControl						*page;
@property(nonatomic, assign) id <UIFocusImageViewDelegate>			delegate;
- (void)scrollNext;
@end
