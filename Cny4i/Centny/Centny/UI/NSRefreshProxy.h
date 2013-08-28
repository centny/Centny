//
//  NSRefreshProxy.h
//  Centny
//
//  Created by Centny on 9/24/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Centny.h"
//the drag direction for refresh.
typedef enum NSDragDirection{
    DD_UP=1,    
    DD_DOWN,
    DD_LEFT,
    DD_RIGHT
}NSDragDirection;
//the proxy for refresh view.
@interface NSRefreshProxy : NSObject{
    float _refreshDragDis;                      //the refresh view size.
    CGPoint _refreshBeginPoint;                 //the refresh begine point,default is (0,0)
    NSDragDirection _refreshDirection;          //the refresh direction,default DD_DOWN
    UIEdgeInsets _defaultInsets;                //the scroll default insets,deafult is (0,0,0,0)
    id<UIRefreshViewDelegate> _rdelegate;       //the refresh view delegate.
}
//require fields.
@property(nonatomic,assign)float refreshDragDis;
@property(nonatomic,assign)id<UIRefreshViewDelegate> rdelegate;
//optional fields.
@property(nonatomic,assign)CGPoint refreshBeginPoint;
@property(nonatomic,assign)NSDragDirection refreshDirection;
@property(nonatomic,assign)UIEdgeInsets defaultInsets;
///////////////////////////////////////////////////////////////////////////////////////////
//the methods for the target scorll view call back.
- (void)scrollViewDidScroll:(UIScrollView*)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView isNeedRefresh:(BOOL(^)(void))isNeedRefresh onRefresh:(void(^)(void))onRefresh;
- (void)refreshCompleted:(UIScrollView*)scrollView finished:(void(^)(BOOL))finished;
@end
