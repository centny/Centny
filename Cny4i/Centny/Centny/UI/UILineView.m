//
//  UILineView.m
//  Centny
//
//  Created by Centny on 6/29/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "UILineView.h"
#import "../GeneralDef.h"
#import "LineDrawer.h"

@interface UILineView ()
@end
@implementation UILineView
@synthesize drawer;
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];

	if (self) {
		drawer = [[LineDrawer alloc]init];
	}

	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {
		drawer = [[LineDrawer alloc]init];
	}

	return self;
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
	if ([@"lines" isEqualToString : keyPath]) {
		NSString	*val	= value;
		NSArray		*ary	= [val componentsSeparatedByString:@","];

		if (ary.count < 4) {
			return;
		}

		for (int i = 0; i < 4; i++) {
			if (![ary[i] isEqualToString:@"1"]) {
				continue;
			}

			switch (i) {
				case 0:
					[self addLeftLine];
					break;

				case 1:
					[self addTopLine];
					break;

				case 2:
					[self addRightLine];
					break;

				case 3:
					[self addBottomLine];
					break;

				default:
					return;
			}
		}
	} else {
		[super setValue:value forKeyPath:keyPath];
	}
}

- (void)addTopLine
{
	CGRect rect = self.frame;

	[drawer addLine:[CGTwoPoint twoPoint:(0) b:(0) c:(rect.size.width) d:(0)]];
}

- (void)addBottomLine
{
	CGRect rect = self.frame;

	[drawer addLine:[CGTwoPoint twoPoint:(0) b:rect.size.height c:(rect.size.width) d:rect.size.height]];
}

- (void)addVCenterLine
{
	[drawer addLine:[CGTwoPoint twoPoint:FRAM_W(self) / 2 b:FRAM_H(self) c:FRAM_W(self) / 2 d:0]];
}

- (void)addHCenterLine
{
	[drawer addLine:[CGTwoPoint twoPoint:0 b:FRAM_H(self) / 2 c:FRAM_W(self) d:FRAM_H(self) / 2]];
}

- (void)addLeftLine
{
	CGRect rect = self.frame;

	[drawer addLine:[CGTwoPoint twoPoint:(0) b:(0) c:(0) d:rect.size.height]];
}

- (void)addRightLine
{
	[drawer addLine:[CGTwoPoint twoPoint:FRAM_W(self) b:0 c:FRAM_W(self) d:FRAM_H(self)]];
}

- (void)addLine:(CGTwoPoint *)tp
{
	[drawer addLine:tp];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	if (drawer) {
		[drawer drawRect:rect];
	}
}

- (void)dealloc
{
	[super dealloc];
	IF_REL(drawer);
}

@end
