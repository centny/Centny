//
//  UIFocusImageView.m
//  FFS_Framework
//
//  Created by ShaoHong Wen on 7/6/12.
//  Copyright (c) 2012 fengfeng. All rights reserved.
//

#import "UIFocusImageView.h"
@interface UIFocusImageView ()

@end
//
@implementation UIFocusImageView
@synthesize currentPage				= _currentPage, pageIdx = _pageIdx;
@synthesize limitScroll				= _limitScroll;
@synthesize scroll, page, delegate	= _delegate;
//
- (void)updatePage
{
	page.currentPage = _currentPage;
	[page updateCurrentPageDisplay];
	scroll.contentOffset = CGPointMake(_pageIdx * ssize.width, 0);
}

- (void)setLimitScroll:(BOOL)limitScroll
{
	_limitScroll = limitScroll;

	if (_limitScroll) {
		page.numberOfPages = [_subviews count];
	} else {
		page.numberOfPages = [_subviews count] - 2;
	}

	[self setCurrentPage:_currentPage];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
	if ((currentPage < 0) || (currentPage >= [_subviews count])) {
		return;
	}

	if (_limitScroll) {
		_pageIdx = currentPage;
	} else {
		if (currentPage >= [_subviews count]) {
			return;
		}

		_pageIdx = currentPage + 1;
	}

	_currentPage = currentPage;
	[self updatePage];
}

- (void)setPageIdx:(NSInteger)pageIdx
{
	if ((pageIdx < 0) || (pageIdx >= [_subviews count])) {
		return;
	}

	if (_limitScroll) {
		_currentPage	= pageIdx;
		_pageIdx		= pageIdx;
	} else {
		if (pageIdx == ([_subviews count] - 1)) {
			_currentPage	= 0;
			_pageIdx		= _currentPage + 1;
		} else if (0 == pageIdx) {
			_currentPage	= [_subviews count] - 3;
			_pageIdx		= _currentPage + 1;
		} else {
			_currentPage	= pageIdx - 1;
			_pageIdx		= pageIdx;
		}
	}

	[self updatePage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	self.pageIdx = scroll.contentOffset.x / ssize.width;

	if (_delegate) {
		[_delegate didScroll:self.pageIdx];
	}
}

- (void)initPage:(UIPageControl *)_page views:(NSArray *)views
{
	_subviews = [views retain];
	UIView *sview = [views objectAtIndex:0];
	ssize	= sview.frame.size;
	scroll	= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	scroll.clipsToBounds	= NO;
	scroll.pagingEnabled	= YES;
	int vcount = [views count];
	scroll.contentSize = CGSizeMake(ssize.width * ([views count]), ssize.height);
	scroll.showsHorizontalScrollIndicator = NO;
	scroll.delegate = self;

	for (int i = 0; i < vcount; i++) {
		UIView *v = [views objectAtIndex:i];
		v.frame = CGRectMake(i * ssize.width, 0, ssize.width, ssize.height);
		[scroll addSubview:v];
	}

	[self addSubview:scroll];
	//
	page = [_page retain];
	page.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	page.userInteractionEnabled		= NO;
	page.hidesForSinglePage			= YES;
	[self addSubview:page];
	self.clipsToBounds	= YES;
	self.limitScroll	= YES;
	self.currentPage	= 0;
}

- (id)initWithFrame:(CGRect)frame pc:(UIPageControl *)pc views:(NSArray *)views
{
	self = [super initWithFrame:frame];

	if (self) {
		[self initPage:pc views:views];
	}

	return self;
}

- (id)initWithFrame:(CGRect)frame page:(Class)pclass views:(NSArray *)views
{
	self = [super initWithFrame:frame];

	if (self) {
		UIView *sview = [views objectAtIndex:0];
		ssize = sview.frame.size;
		//        CGRect rt=CGRectMake((self.frame.size.width-ssize.width)/2, (self.frame.size.height-ssize.height)/2,ssize.width , ssize.height);
		UIPageControl *pc = [[pclass alloc] initWithFrame:CGRectMake(0, 0, ssize.width, 15)];
		[pc setBackgroundColor:[UIColor clearColor]];
		[self initPage:pc views:views];
		[pc release];
	}

	return self;
}

- (void)scrollNext
{
	[UIView animateWithDuration:0.4 animations:^{
		scroll.contentOffset = CGPointMake(scroll.contentOffset.x + ssize.width, 0);
	} completion:^(BOOL finished) {
		[self scrollViewDidEndDecelerating:nil];
	}];
}

/*
 *   // Only override drawRect: if you perform custom drawing.
 *   // An empty implementation adversely affects performance during animation.
 *   - (void)drawRect:(CGRect)rect
 *   {
 *    // Drawing code
 *   }
 */
- (void)dealloc
{
	if (_subviews) {
		[_subviews release];
		_subviews = 0;
	}

	[super dealloc];
}

@end
