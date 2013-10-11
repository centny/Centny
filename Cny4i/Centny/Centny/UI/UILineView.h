//
//  UILineView.h
//  Centny
//
//  Created by Centny on 6/29/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineDrawer.h"
// can adding some normal line for the UIView.
@interface UILineView : UIView {
	LineDrawer *drawer;
}
@property(nonatomic, retain) LineDrawer *drawer;
- (void)addTopLine;
- (void)addBottomLine;
- (void)addHCenterLine;
- (void)addVCenterLine;
- (void)addLeftLine;
- (void)addRightLine;
- (void)addLine:(CGTwoPoint *)tp;
@end
