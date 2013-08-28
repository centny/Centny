//
//  UITableExtView.m
//  Centny
//
//  Created by Centny on 9/24/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "UITableExtView.h"
#import "../GeneralDef.h"
#import "UIRefreshView.h"
#import "NSRefreshProxy.h"

@interface UITableExtViewDelegateImpl:NSObject<UITableViewDelegate>{
    id<UITableExtViewDelegate> _tdelegate;  //the extend table view deleagate.
    NSRefreshProxy *_rproxy;                //the refresh proxy.
    UITableExtView *_table;                 //the target table view.
}
@property(nonatomic,assign)id<UITableExtViewDelegate> tdelegate;
@property(nonatomic,assign)NSRefreshProxy *rproxy;
@property(nonatomic,assign)UITableExtView *table;
-(void)refreshCompleted:(void(^)(BOOL))finished;
@end

@interface UITableExtView(){
    NSRefreshProxy *_rproxy;                //the refresh proxy.
    UITableExtViewDelegateImpl *_dimpl;     //the table view delegate implements.
    
}
@end

@implementation UITableExtView
@synthesize refreshView=_refreshView,rdelegate=_rdelegate,tdelegate=_tdelegate;
-(id)initWithFrame:(CGRect)frame refreshView:(UIView *)refreshView{
    self=[super initWithFrame:frame];
    if(self){
        _refreshView=[refreshView retain];
        _refreshView.frame=CGRectMake(0, -FRAM_H(_refreshView), FRAM_W(_refreshView), FRAM_H(_refreshView));
//        self.contentInset=UIEdgeInsetsMake(-FRAM_H(_refreshView), 0, 0, 0);
//        self.tableHeaderView=_refreshView;
        [self addSubview:_refreshView];
        _rproxy=[[NSRefreshProxy alloc]init];
        _rproxy.refreshDragDis=_refreshView.frame.size.height;
        _rproxy.defaultInsets=self.contentInset;
        _rproxy.refreshBeginPoint=CGPointMake(0,0);
        _dimpl=[[UITableExtViewDelegateImpl alloc]init];
        _dimpl.rproxy=_rproxy;
        _dimpl.table=self;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    UIRefreshView *rv=[[[UIRefreshView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, REFRESH_SCROLL_H) style:RVS_W_B]autorelease];
    self=[self initWithFrame:frame refreshView:rv];
    self.rdelegate=rv;
    return self;
}
-(void)setDelegate:(id<UITableViewDelegate>)delegate{
    if(delegate==_dimpl){
        super.delegate=delegate;
    }else{
        self.tdelegate=(id<UITableExtViewDelegate>)delegate;
    }
}
-(void)setTdelegate:(id<UITableExtViewDelegate>)tdelegate{
    _tdelegate=tdelegate;
    _dimpl.tdelegate=_tdelegate;
    self.delegate=_dimpl;
}
-(void)setRdelegate:(id<UIRefreshViewDelegate>)rdelegate{
    _rdelegate=rdelegate;
    _rproxy.rdelegate=_rdelegate;
}
-(void)refreshCompleted:(void(^)(BOOL))finished;{
    [_dimpl refreshCompleted:finished];
}
-(void)dealloc{
    IF_REL(_refreshView);
    IF_REL(_rproxy);
    IF_REL(_dimpl);
    NSRelLog(@"UITableExtView release...");
    [super dealloc];
}
@end

@implementation UITableExtViewDelegateImpl
@synthesize tdelegate=_tdelegate,rproxy=_rproxy,table=_table;
///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////implemented delegate method////////////////////////
///////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_rproxy scrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y == (scrollView.contentSize.height - scrollView.frame.size.height)) {
        if([_tdelegate respondsToSelector:@selector(onNextPage:)]){
            [_tdelegate onNextPage:_table];
        }
    }
    if([_tdelegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [_tdelegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_rproxy scrollViewDidEndDragging:scrollView isNeedRefresh:^{
        BOOL nr=NO;
        if([_tdelegate respondsToSelector:@selector(isNeedRefresh:)]){
            nr=[_tdelegate isNeedRefresh:_table];
        }
        return nr;
    } onRefresh:^{
        if([_tdelegate respondsToSelector:@selector(onRefresh:)]){
            [_tdelegate onRefresh:_table];
        }
    }];
    if([_tdelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]){
        [_tdelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
///////////////////////////////////////////////////////////////////////////////////
-(void)refreshCompleted:(void(^)(BOOL))finished;{
    [_rproxy refreshCompleted:_table finished:finished];
}
-(BOOL)respondsToSelector:(SEL)aSelector{
    if(aSelector==@selector(scrollViewDidScroll:)){
        return YES;
    }
    if(aSelector==@selector(scrollViewDidEndDragging:willDecelerate:)){
        return YES;
    }
    return [_tdelegate respondsToSelector:aSelector];
}
-(void)dealloc{
    NSRelLog(@"UITableExtViewDelegateImpl release...");
    [super dealloc];
}
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////default method for the delegate.////////////////////////
///////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
	[_tdelegate scrollViewDidZoom:scrollView];
}
-  ( void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[_tdelegate scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
	[_tdelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	[_tdelegate scrollViewWillBeginDecelerating:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	[_tdelegate scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
	[_tdelegate scrollViewDidEndScrollingAnimation:scrollView];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return [_tdelegate viewForZoomingInScrollView:scrollView];
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
	[_tdelegate scrollViewWillBeginZooming:scrollView withView:view];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
	[_tdelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
	return [_tdelegate scrollViewShouldScrollToTop:scrollView];
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
	[_tdelegate scrollViewDidScrollToTop:scrollView];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	[_tdelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
	[_tdelegate tableView:tableView willDisplayHeaderView:view forSection:section];
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
	[_tdelegate tableView:tableView willDisplayFooterView:view forSection:section];
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
	[_tdelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
	[_tdelegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
}
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section{
	[_tdelegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [_tdelegate tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return [_tdelegate tableView:tableView heightForHeaderInSection:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return [_tdelegate tableView:tableView heightForFooterInSection:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	return [_tdelegate tableView:tableView viewForHeaderInSection:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	return [_tdelegate tableView:tableView viewForFooterInSection:section];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	[_tdelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
	return [_tdelegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
	[_tdelegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
	[_tdelegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	return [_tdelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
}
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
	return [_tdelegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[_tdelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
	[_tdelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [_tdelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [_tdelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
	return [_tdelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
	[_tdelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
	[_tdelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
	return [_tdelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
}
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [_tdelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [_tdelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
	return [_tdelegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
	[_tdelegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
}

@end
