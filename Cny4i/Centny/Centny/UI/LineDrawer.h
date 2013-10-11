//
//  LineDrawer.h
//  Centny
//
//  Created by Centny on 7/18/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CGTwoPoint : NSObject {
	CGPoint one;
	CGPoint two;
}
@property(nonatomic, assign) CGPoint	one;
@property(nonatomic, assign) CGPoint	two;
//
- (id)initWith:(float)a b:(float)b c:(float)c d:(float)d;
//
+ (id)twoPoint:(float)a b:(float)b c:(float)c d:(float)d;
@end
CG_INLINE CGTwoPoint *
CGTwoPointMake(float a, float b, float c, float d)
{
	return [CGTwoPoint twoPoint:a b:b c:c d:d];
}

//
// using drawer in UIView drawRect method by calling the Drawer drawRect method.
//
@interface LineDrawer : NSObject {
	NSMutableArray	*_lines;
	UIColor			*_lineColor;
	float			_lineSize;
	float			_lineDashPhase;
	float			*_lineDashLengths;
	int				_lineDashLenCount;
	BOOL			_lineDash;
}
@property(nonatomic, retain) UIColor	*lineColor;				// default blank.
@property(nonatomic, assign) float		lineSize;				// default is 1.
@property(nonatomic, assign) BOOL		lineDash;				// default is NO.
@property(nonatomic, assign) float		lineDashPahse;			// defult is 2.
- (void)setLineDashLengths:(float *)lengths count:(int)count;	// default is {3.0,3.0}
// add line.
- (void)addLine:(CGTwoPoint *)tp;
- (void)addLines:(NSArray *)tps;
// call it in UIView drawRect.
- (void)drawRect:(CGRect)rt;
@end
