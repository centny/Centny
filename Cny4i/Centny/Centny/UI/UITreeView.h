//
//  UITreeView.h
//  PCECommerce
//
//  Created by ShaoHong Wen on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableExtView.h"
//
//

#define TV_DEFAULT_INDENT		10	// the tree default indent distance.
#define TV_DEFAULT_CELL_HEIGHT	50	// the tree default row height.
// the cell status for the parent node.
typedef enum {
	CELL_CLOSED = 1, CELL_OPENED, CELL_NORMAL, CELL_SELECTED
} CellStatus;
//
@class	UITreeView;
@class	UITreeIconView;
// the Tree view dalegate define.
@protocol UITreeViewDelegate <UITableExtViewDelegate>
@required
// check the node if a parent node.
- (BOOL)isParentNode:(NSDictionary *)sobj;
// create the cell view,the return UIView is autorelease.
- (UIView *)cellView:(UITreeView *)tree sobj:(NSDictionary *)sobj cell:(UITableViewCell *)cell;
// Subtree view created callback mehtod,the subtree must be initialed in this method.
- (void)onSubtreeCreated:(UITreeView *)subtree parent:(NSDictionary *)sobj;
@optional
// the row tree icon create method,the return UITreeIconView is autorelease.
- (UITreeIconView *)rowTreeLeftIconView:(NSDictionary *)sobj cell:(UITableViewCell *)cell;
// the row tree icon create method,the return UITreeIconView is autorelease.
- (UITreeIconView *)rowTreeRightIconView:(NSDictionary *)sobj cell:(UITableViewCell *)cell;
- (void)onSelectedRow:(UITreeView *)subtree sobj:(NSDictionary *)sobj cell:(UITableViewCell *)cell;
- (void)onDeselectedRow:(UITreeView *)subtree sobj:(NSDictionary *)sobj cell:(UITableViewCell *)cell;
// on selecte on leaf node.
- (void)onSelectLeaf:(NSDictionary *)row;
// on select on parent node,return NO will execute nothing.
- (BOOL)onSelectParent:(NSDictionary *)row;
// the table view row height.
- (float)cellHeight;
// the distance of the tree indent.
- (float)subIndent;
@end
//
//
// the tree icon view.
@interface UITreeIconView : UIView {
	CellStatus _status;	// current status.
}
// set the image by statue.
- (void)setImage:(UIImage *)img status:(CellStatus)status;
// create one empty icon view with white backgroud.
+ (id)emptyIconView:(CGRect)frame;
// set the current status.
@property (nonatomic, assign) CellStatus status;
@end

//
// the tree primary view.
@interface UITreeView : UITableExtView <UITableExtViewDelegate>{
	id <UITreeViewDelegate> _delegatetvd;
}
// set the tree data for current tree layer.
- (void)dataWithArray:(NSArray *)ary;
// the tree delegate.
@property (nonatomic, assign) id <UITreeViewDelegate>	delegatetvd;
@property (nonatomic, assign) UITreeView				*parent;
@end

