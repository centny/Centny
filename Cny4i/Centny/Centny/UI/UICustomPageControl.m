//
//  UICustomPageControl.m
//  FFS_Framework
//
//  Created by ShaoHong Wen on 7/2/12.
//  Copyright (c) 2012 fengfeng. All rights reserved.
//

#import "UICustomPageControl.h"

@implementation UICustomPageControl {
	UIImage *imagePageStateNormal;
	UIImage *imagePageStateHighlighted;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {
		imagePageStateNormal		= [[UIImage imageNamed:@"featured_page_normal.png"]retain];
		imagePageStateHighlighted	= [[UIImage imageNamed:@"featured_page_hightlight.png"]retain];
	}

	return self;
}

- (void)updateCurrentPageDisplay
{
	[super updateCurrentPageDisplay];

	if (imagePageStateNormal && imagePageStateHighlighted) {
		NSArray *subview = self.subviews;	// 获取所有子视图

		for (NSInteger i = 0; i < [subview count]; i++) {
			UIImageView *dot = [subview objectAtIndex:i];	// 以下不解释, 看了基本明白
			dot.image = self.currentPage == i ? imagePageStateHighlighted : imagePageStateNormal;
		}
	}
}

- (void)dealloc
{
	[imagePageStateNormal release];
	[imagePageStateHighlighted release];
	[super dealloc];
}

@end
