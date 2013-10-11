//
//  UITreeView.m
//  PCECommerce
//
//  Created by ShaoHong Wen on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UITreeView.h"
#import "Centny.h"
//
@implementation UITreeIconView
@synthesize status = _status;
- (void)setStatus:(CellStatus)status
{
	_status = status;

	for (UIView *v in self.subviews) {
		if ([[v class]isSubclassOfClass:[UIImageView class]]) {
			v.hidden = YES;
		}
	}

	UIImageView *iv = (UIImageView *)[self viewWithTag:(int)status];

	if (iv) {
		iv.hidden = NO;
	}
}

- (void)setImage:(UIImage *)img status:(CellStatus)status
{
	UIImageView *iv = (UIImageView *)[self viewWithTag:(int)status];

	if (iv) {
		iv.image = img;
	} else {
		iv			= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		iv.image	= img;
		iv.hidden	= (_status != status);
		iv.tag		= status;
		[self addSubview:iv];
		[iv release];
	}
}

+ (id)emptyIconView:(CGRect)frame
{
	UITreeIconView *view = [[[UITreeIconView alloc] initWithFrame:frame] autorelease];

	view.backgroundColor = [UIColor clearColor];
	return view;
}

@end

//
// private interface declaration.
@interface UITreeView () <UITableViewDataSource>{
	UITreeView				*_parent;		// parent tree view.
	NSDictionary			*_parentObj;	// parent data object.
	NSMutableDictionary		*_subtree;		// subtree views.
	NSMutableArray			*_data;			// show data.
	NSMutableArray			*_rheidht;		// row height.
	NSNotificationCenter	*_notice;		// the notice.
	//
	float _indent;							// current indent distance.
}
- (id)initWithFrame:(CGRect)frame notice:(NSNotificationCenter *)notice;
@property (nonatomic, retain) NSDictionary			*parentObj;
@property (nonatomic, assign) float					indent;
@property (nonatomic, retain) NSNotificationCenter	*notice;
@end
//
//
@implementation UITreeView
@synthesize parent		= _parent, parentObj = _parentObj;
@synthesize delegatetvd = _delegatetvd, indent = _indent;
@synthesize notice		= _notice;
- (BOOL)checkRemoveSubtree:(int)row
{
	int idx = row + 1;

	if (idx >= [_data count]) {
		return NO;
	}

	NSDictionary	*next	= [_data objectAtIndex:idx];
	UITreeView		*sub	= nil;

	if (![next objectForKey:@"subtree"]) {
		return NO;
	}

	NSString *key = [next objectForKey:@"subview"];
	sub = [_subtree objectForKey:key];

	if (sub) {
		sub.frame = CGRectMake(0, 0, 0, 0);
		[sub.parent upateFrame:sub];
		[_subtree removeObjectForKey:key];
		[_data removeObjectAtIndex:idx];
		[_rheidht removeObjectAtIndex:idx];
		[self reloadData];
		return YES;
	}

	return NO;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//    NSLog(@"didDeselectRowAtIndexPath:^^^^^^^^^^^sssssss!");
	UITableViewCell *cell	= [self cellForRowAtIndexPath:indexPath];
	NSDictionary	*sobj	= [_data objectAtIndex:indexPath.row];

	if (cell) {
		UITreeIconView *iv = nil;

		for (UIView *v in cell.subviews) {
			if (![[v class]isSubclassOfClass:[UITreeIconView class]]) {
				continue;
			}

			iv = (UITreeIconView *)v;

			if (iv.status == CELL_SELECTED) {
				iv.status = CELL_NORMAL;
				//                NSLog(@"^^^^^^^^^^^sssssss!");
			}
		}
	}

	if ([_delegatetvd respondsToSelector:@selector(onDeselectedRow:sobj:cell:)]) {
		[_delegatetvd onDeselectedRow:self sobj:sobj cell:cell];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//
	[_notice postNotificationName:@"unselect" object:self];
	//
	NSDictionary *sobj = [_data objectAtIndex:indexPath.row];

	if ([_delegatetvd respondsToSelector:@selector(onSelectedRow:sobj:cell:)]) {
		UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
		[_delegatetvd onSelectedRow:self sobj:sobj cell:cell];
	}

	if ([_delegatetvd isParentNode:sobj]) {
		if ([_delegatetvd respondsToSelector:@selector(onSelectParent:)]) {
			if (![_delegatetvd onSelectParent:sobj]) {	// return no will execute nothing.
				return;
			}
		}

		if ([self checkRemoveSubtree:indexPath.row]) {
			return;
		}

		UITreeView *sub = nil;
		sub				= [[[self class] alloc] initWithFrame:CGRectMake(0, 0, FRAM_W(self), 10) notice:_notice];
		sub.delegatetvd = _delegatetvd;
		sub.parent		= self;
		sub.parentObj	= sobj;

		//        sub.separatorColor=[self.separatorColor colorWithAlphaComponent:1];
		if ([_delegatetvd respondsToSelector:@selector(subIndent)]) {
			sub.indent = _indent + [_delegatetvd subIndent];
		} else {
			sub.indent = _indent + TV_DEFAULT_INDENT;
		}

		[_delegatetvd onSubtreeCreated:sub parent:sobj];
		[_subtree setObject:sub forKey:[NSString stringWithFormat:@"%p", sub]];
		[sub release];
	} else {
		if ([_delegatetvd respondsToSelector:@selector(onSelectLeaf:)]) {
			[_delegatetvd onSelectLeaf:sobj];
		}

		UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];

		if (cell) {
			UITreeIconView *iv = nil;

			for (UIView *v in cell.subviews) {
				if (![[v class]isSubclassOfClass:[UITreeIconView class]]) {
					continue;
				}

				iv = (UITreeIconView *)v;

				if (iv.status == CELL_NORMAL) {
					iv.status = CELL_SELECTED;
				}
			}
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[_rheidht objectAtIndex:indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell	= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	NSDictionary	*sobj	= [_data objectAtIndex:indexPath.row];

	if ([sobj objectForKey:@"subtree"]) {
		[cell addSubview:[_subtree objectForKey:[sobj objectForKey:@"subview"]]];
	} else {
		UITreeIconView *lIconView = nil, *rIconView = nil;

		if ([_delegatetvd respondsToSelector:@selector(rowTreeLeftIconView:cell:)]) {
			lIconView = [_delegatetvd rowTreeLeftIconView:sobj cell:cell];
			CGRect rt = lIconView.frame;
			rt.origin		= CGPointMake(_indent, rt.origin.y);
			lIconView.frame = rt;

			if ([_delegatetvd isParentNode:sobj]) {
				BOOL isOpened = (((indexPath.row + 1) < [_data count]) && (nil != [[_data objectAtIndex:(indexPath.row + 1)] objectForKey:@"subtree"]));
				[lIconView setStatus:(isOpened ? CELL_OPENED : CELL_CLOSED)];
			}

			[cell addSubview:lIconView];
		}

		if ([_delegatetvd respondsToSelector:@selector(rowTreeRightIconView:cell:)]) {
			rIconView = [_delegatetvd rowTreeRightIconView:sobj cell:cell];
			//            CGRect rt = rIconView.frame;
			//            rt.origin = CGPointMake(FRAM_W(self)-rt.size.width, rt.origin.y);
			//            rIconView.frame = rt;

			if ([_delegatetvd isParentNode:sobj]) {
				BOOL isOpened = (((indexPath.row + 1) < [_data count]) && (nil != [[_data objectAtIndex:(indexPath.row + 1)] objectForKey:@"subtree"]));
				[rIconView setStatus:(isOpened ? CELL_OPENED : CELL_CLOSED)];
			}

			[cell addSubview:rIconView];
		}

		UIView *subview = [_delegatetvd cellView:self sobj:sobj cell:cell];

		if (subview) {
			CGRect rt = subview.frame;

			if (lIconView) {
				rt.origin = CGPointMake(FRAM_XW(lIconView), rt.origin.y);
			} else {
				rt.origin = CGPointMake(_indent, rt.origin.y);
			}

			if (rIconView) {
				rt.size = CGSizeMake(FRAM_W(self) - FRAM_W(rIconView) - FRAM_XW(lIconView), rt.size.height);
			} else {
				rt.size = CGSizeMake(FRAM_W(self) - FRAM_XW(lIconView), rt.size.height);
			}

			subview.frame = rt;
			[cell addSubview:subview];
		}
	}

	return cell;
}

- (BOOL)isNeedRefresh:(UITableExtView *)tableview
{
	if ([_delegatetvd respondsToSelector:@selector(isNeedRefresh:)]) {
		return [_delegatetvd isNeedRefresh:tableview];
	} else {
		return NO;
	}
}

- (void)onRefresh:(UITableExtView *)tableview
{
	if ([_delegatetvd respondsToSelector:@selector(onRefresh:)]) {
		[_delegatetvd onRefresh:tableview];
	}
}

- (void)loadSubtreeComplete:(UITreeView *)subtree
{
	int idx = [_data indexOfObject:subtree.parentObj];

	if ((idx < 0) || (idx >= [_data count])) {
		NSDLog(@"unknow object");
		return;
	}

	[_data insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"true", @"subtree", [NSString stringWithFormat:@"%p", subtree], @"subview", nil] atIndex:(idx + 1)];
	[_rheidht insertObject:[NSNumber numberWithFloat:0] atIndex:(idx + 1)];
}

- (void)upateFrame:(UITreeView *)subtree
{
	int			idx		= [_data indexOfObject:subtree.parentObj];
	NSNumber	*old	= [_rheidht objectAtIndex:(idx + 1)];

	if (_parent) {
		CGRect rt = self.frame;
		rt.size		= CGSizeMake(rt.size.width, rt.size.height + FRAM_H(subtree) - old.floatValue);
		self.frame	= rt;
		[_parent upateFrame:self];
	}

	[_rheidht replaceObjectAtIndex:(idx + 1) withObject:[NSNumber numberWithFloat:FRAM_H(subtree)]];
	[self reloadData];
}

- (void)dataWithArray:(NSArray *)ary
{
	[_data removeAllObjects];
	[_rheidht removeAllObjects];
	[_data addObjectsFromArray:ary];
	int		dlen = [_data count];
	float	dheight;

	if ([_delegatetvd respondsToSelector:@selector(cellHeight)]) {
		dheight = [_delegatetvd cellHeight];
	} else {
		dheight = TV_DEFAULT_CELL_HEIGHT;
	}

	for (int i = 0; i < dlen; i++) {
		[_rheidht addObject:[NSNumber numberWithFloat:dheight]];
	}

	if (_parent) {
		CGRect rt = self.frame;
		rt.size		= CGSizeMake(rt.size.width, dlen * dheight);
		self.frame	= rt;
		[_parent loadSubtreeComplete:self];
		[_parent upateFrame:self];
	}

	[self reloadData];
}

- (void)unselect:(NSNotification *)notice
{
	UITreeView *sender = [notice object];

	if (self != sender) {
		[self tableView:self didDeselectRowAtIndexPath:[self indexPathForSelectedRow]];
		[self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:NO];
	}
}

- (id)initWithFrame:(CGRect)frame notice:(NSNotificationCenter *)notice
{
	self = [super initWithFrame:frame];

	if (self) {
		// Initialization code
		_subtree		= [[NSMutableDictionary alloc] init];
		_data			= [[NSMutableArray alloc] init];
		_rheidht		= [[NSMutableArray alloc] init];
		self.dataSource = self;
		self.tdelegate	= self;
		_notice			= [notice retain];
		[_notice addObserver:self selector:@selector(unselect:) name:@"unselect" object:nil];
	}

	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {
		// Initialization code
		_subtree		= [[NSMutableDictionary alloc] init];
		_data			= [[NSMutableArray alloc] init];
		_rheidht		= [[NSMutableArray alloc] init];
		self.dataSource = self;
		self.delegate	= self;
		UIRefreshView *rv = (UIRefreshView *)self.refreshView;
		rv.date.font	= [UIFont systemFontOfSize:12];
		rv.info.font	= [UIFont systemFontOfSize:15];
		_notice			= [[NSNotificationCenter alloc] init];
		[_notice addObserver:self selector:@selector(unselect:) name:@"unselect" object:nil];
	}

	return self;
}

- (void)dealloc
{
	[_notice removeObserver:self name:@"unselect" object:nil];
	IF_REL(_notice);
	IF_REL(_data);
	IF_REL(_rheidht);
	IF_REL(_subtree);
	IF_REL(_parentObj);
	NSDLog(@"UITreeView release...");
	[super dealloc];
}

@end
