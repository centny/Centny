//
//  LineDrawer.m
//  Centny
//
//  Created by Centny on 7/18/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "LineDrawer.h"

@implementation CGTwoPoint
@synthesize one;
@synthesize two;
- (id)initWith:(float)a b:(float)b c:(float)c d:(float)d
{
	self = [super init];

	if (self) {
		one = CGPointMake(a, b);
		two = CGPointMake(c, d);
	}

	return self;
}

+ (id)twoPoint:(float)a b:(float)b c:(float)c d:(float)d
{
	return [[[CGTwoPoint alloc] initWith:a b:b c:c d:d] autorelease];
}

- (void)dealloc
{
	[super dealloc];
}

@end
//
@implementation LineDrawer
@synthesize lineColor		= _lineColor, lineSize = _lineSize, lineDash = _lineDash;
@synthesize lineDashPahse	= _lineDashPhase;
- (void)setLineDashLengths:(float *)lengths count:(int)count
{
	if (_lineDashLengths) {
		free(_lineDashLengths);
		_lineDashLengths = nil;
	}

	_lineDashLenCount	= count;
	_lineDashLengths	= calloc(_lineDashLenCount, sizeof(float));
	memccpy(_lineDashLengths, lengths, _lineDashLenCount, sizeof(float) * _lineDashLenCount);
}

- (id)init
{
	self = [super init];

	if (self) {
		_lineColor	= [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] retain];
		_lines		= [[NSMutableArray alloc] init];
		_lineSize	= 1;
		_lineDash	= NO;
		float dl[] = {3.0, 3.0};
		[self setLineDashLengths:dl count:2];
	}

	return self;
}

- (void)addLine:(CGTwoPoint *)tp
{
	[_lines addObject:tp];
}

- (void)addLines:(NSArray *)tps
{
	[_lines addObjectsFromArray:tps];
}

- (void)drawRect:(CGRect)rt
{
	if ((nil == _lines) || ([_lines count] == 0)) {
		return;
	}

	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(ctx, [self.lineColor CGColor]);
	CGContextSetLineWidth(ctx, _lineSize);

	if (_lineDash) {
		CGContextSetLineDash(ctx, _lineDashPhase, _lineDashLengths, _lineDashLenCount);
	}

	for (CGTwoPoint *tp in _lines) {
		CGContextMoveToPoint(ctx, tp.one.x, tp.one.y);
		CGContextAddLineToPoint(ctx, tp.two.x, tp.two.y);
	}

	CGContextClosePath(ctx);
	CGContextStrokePath(ctx);
}

- (void)dealloc
{
	if (_lineColor) {
		[_lineColor release];
		_lineColor = nil;
	}

	if (_lines) {
		[_lines release];
		_lines = nil;
	}

	if (_lineDashLengths) {
		free(_lineDashLengths);
		_lineDashLengths = nil;
	}

	[super dealloc];
}

@end
