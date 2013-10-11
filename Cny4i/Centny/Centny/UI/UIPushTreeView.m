//
//  UIPushTreeView.m
//  PCECommerce
//
//  Created by ShaoHong Wen on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIPushTreeView.h"
#import "Centny.h"
@interface UIPushTreeView () <UITableViewDataSource, UITableViewDelegate>{
	BOOL _isRootNode;
}
@property(nonatomic, assign) BOOL isRootNode;
@end

@implementation UIPushTreeView
@synthesize data		= _data, delegateptvd = _delegateptvd, isRootNode = _isRootNode;
@synthesize parentObj	= _parentObj, parent = _parent;
@synthesize list		= _list;
//
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {
		// Initialization code
		_isRootNode = YES;
	}

	return self;
}

- (UIView *)createHeader
{
	UIView *header = nil;

	if ([_delegateptvd respondsToSelector:@selector(headerView:tree:)]) {
		header = [_delegateptvd headerView:_parentObj tree:self];
	}

	if (nil == header) {
		header = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, PTV_HEADER_H)]autorelease];
		header.backgroundColor = [UIColor whiteColor];
	}

	if (_isRootNode) {
		return header;
	}

	UIButton *btn = nil;

	if ([_delegateptvd respondsToSelector:@selector(headerBtn:tree:)]) {
		btn = [_delegateptvd headerBtn:_parentObj tree:self];
	}

	if (nil == btn) {
		btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[btn setTitle:@"Back" forState:UIControlStateNormal];
		btn.frame = CGRectMake(0, 0, 2 * PTV_HEADER_H, PTV_HEADER_H);
	}

	[btn addTarget:self action:@selector(clkBack) forControlEvents:UIControlEventTouchUpInside];
	[header addSubview:btn];
	return header;
}

- (void)clkBack
{
	[UIView animateWithDuration:0.5 animations:^{
		CGRect rt = self.frame;
		rt.origin = CGPointMake(FRAM_W(self), 0);
		self.frame = rt;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
}

- (void)setDelegateptvd:(id <UIPushTreeViewDelegate>)delegateptvd
{
	_delegateptvd = delegateptvd;
	UIView *header = [self createHeader];

	if (header) {
		_list = [[UITableView alloc]initWithFrame:CGRectMake(0, FRAM_YH(header), FRAM_W(self), FRAM_H(self) - FRAM_YH(header))];
		[self addSubview:header];
	} else {
		_list = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FRAM_W(self), FRAM_H(self))];
	}

	_list.delegate		= self;
	_list.dataSource	= self;
	[self addSubview:_list];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_data) {
		return [_data count];
	} else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *sobj = [_data objectAtIndex:indexPath.row];

	return [_delegateptvd createTabelCell:tableView row:sobj ptv:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([_delegateptvd respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
		return [_delegateptvd tableView:tableView heightForRowAtIndexPath:indexPath];
	} else {
		return PTV_ROW_H;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *sobj = [_data objectAtIndex:indexPath.row];

	if ([_delegateptvd isParentNode:sobj]) {
		if ([_delegateptvd respondsToSelector:@selector(onSelectParent:)]) {
			if (![_delegateptvd onSelectParent:sobj]) {
				return;
			}
		}

		//
		UIPushTreeView *subview = [[[self class] alloc]initWithFrame:CGRectMake(FRAM_W(self), 0, FRAM_W(self), FRAM_H(self))];
		subview.isRootNode		= NO;
		subview.parentObj		= sobj;
		subview.parent			= self;
		subview.delegateptvd	= _delegateptvd;
		[_delegateptvd onCreateSubtree:subview row:sobj];
		[self addSubview:subview];
		[UIView animateWithDuration:0.5 animations:^{
			CGRect rt = subview.frame;
			rt.origin = CGPointMake(0, 0);
			subview.frame = rt;
		} completion:^(BOOL finished) {}];
		[subview release];
	} else {
		if ([_delegateptvd respondsToSelector:@selector(onSelectLeaf:)]) {
			[_delegateptvd onSelectLeaf:sobj];
		}
	}
}

- (void)dealloc
{
	IF_REL(_list);
	IF_REL(_data);
	NSDLog(@"UIPushTreeView release...");
	[super dealloc];
}

@end
