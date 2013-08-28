//
//  UIPushTreeView.h
//  PCECommerce
//
//  Created by ShaoHong Wen on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//
#define PTV_HEADER_H 50.0
#define PTV_ROW_H 50.0
//
@class UIPushTreeView;
//
//the push tree view delegate.
@protocol UIPushTreeViewDelegate<NSObject>
@required
//create the table view cell.
-(UITableViewCell*)createTabelCell:(UITableView*)table row:(NSDictionary*)row ptv:(UIPushTreeView*)ptv;
//check if a parent node.
-(BOOL)isParentNode:(NSDictionary*)row;
//Subtree view created callback mehtod,the subtree must be initialed in this method.
-(void)onCreateSubtree:(UIPushTreeView*)subtree row:(NSDictionary*)row;
//
@optional
//the header view,return view must be autorelease.parent parameter nil is meaning root node.
-(UIView*)headerView:(NSDictionary*)parent tree:(UIPushTreeView*)tree;
//the header button,return view must be autorelease.
-(UIButton*)headerBtn:(NSDictionary*)parent tree:(UIPushTreeView*)tree;
//the row height.
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//on select one parent node.
-(BOOL)onSelectParent:(NSDictionary*)row;
//on select one leaf node.
-(void)onSelectLeaf:(NSDictionary*)row;
//the data transfer method,it will be call after loadNetData call.
//-(NSArray*)dataByReques:(PCHttpRequestResult*)res;
@end

//the push tree view primary view.
@interface UIPushTreeView : UIView{
    NSArray *_data;
    id<UIPushTreeViewDelegate> _delegateptvd;
    UIPushTreeView *_parent;
    NSDictionary *_parentObj;
    UITableView *_list;
}
//set the tree data.
@property(nonatomic,retain)NSArray* data;
//the delegate.
@property(nonatomic,assign)id<UIPushTreeViewDelegate> delegateptvd;
//the parent view.
@property(nonatomic,assign)UIPushTreeView* parent;
//the parent object.
@property(nonatomic,assign)NSDictionary* parentObj;
//the table view list.
@property(nonatomic,readonly)UITableView* list;
//load the network tree data by URL,it will call the dataByReques to convert the data to array.
//-(void)loadNetData:(NSString*)url;
@end
