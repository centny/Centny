//
//  UIBoundsImageView.m
//  Centny
//
//  Created by Centny on 9/12/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "UIBoundsImageView.h"
#import "../GeneralDef.h"
#import "../ClassExt/ClassExt.h"
#import "../Core/CoreMethod.h"

@interface UIBoundsImageView () {}
@end
@implementation UIBoundsImageView
@synthesize showPoint = _showPoint, ranges = _ranges;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {
		_imageView			= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FRAM_W(self), FRAM_H(self))];
		self.clipsToBounds	= YES;
		[self addSubview:_imageView];
		_ranges = [[NSMutableDictionary alloc]init];
	}

	return self;
}

- (void)setImage:(UIImage *)image
{
	_imageView.frame	= CGRectMake(0, 0, image.size.width, image.size.height);
	_imageView.image	= image;
}

- (UIImage *)image
{
	return _imageView.image;
}

- (void)setShowPoint:(CGPoint)showPoint
{
	_showPoint = showPoint;
	CGRect rt = self.bounds;
	rt.origin	= showPoint;
	self.bounds = rt;
}

- (void)setRange:(float)range
{
	NSArray *ary = [_ranges allKeys];

	_range = range;

	for (NSPart *p in ary) {
		if ([p numberInPart:[NSNumber numberWithFloat:range]]) {
			NSPart *v = [_ranges objectForKey:p];
			self.showPoint = CGPointMake([v.one floatValue], [v.two floatValue]);
			return;
		}
	}

	self.showPoint = CGPointMake(0, 0);
}

- (void)setRangeToPoint:(NSString *)rtp
{
	NSString		*nrtp	= [rtp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSDictionary	*rtpMap = [nrtp dictionaryBy:@"|" kvSeparator:@":"];

	for (NSString *key in rtpMap.allKeys) {
		[_ranges setObject:[NSPart numberPartWith:[rtpMap objectForKey:key] separator:@","] forKey:[NSPart numberPartWith:key separator:@"-"]];
	}
}

- (void)setRangeToPointByFile:(NSString *)name type:(NSString *)type
{
	NSError		*err	= nil;
	NSString	*data	= [NSString stringWithContentsOfFile:FILE_PATH(name, type) encoding:NSUTF8StringEncoding error:&err];

	if (err) {
		NSDLog(@"load data by file faild:%@", [err debugDescription]);
		return;
	}

	[self setRangeToPoint:data];
}

- (void)dealloc
{
	IF_REL(_imageView);
	IF_REL(_ranges);
	[super dealloc];
}

@end
