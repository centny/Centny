//
//  UIBoundsImageView.h
//  Centny
//
//  Created by Centny on 9/12/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Core/NSPart.h"
// the BoundsImageView,it can only show the specified area in targe image.
@interface UIBoundsImageView : UIView {
	UIImageView			*_imageView;
	CGPoint				_showPoint;
	float				_range;
	NSMutableDictionary *_ranges;
}

@property(nonatomic, readonly) UIImageView	*imageView;
@property(nonatomic, retain) UIImage		*image;
// move the image point to the view zero point.
@property(nonatomic, assign) CGPoint showPoint;
//////////////////////////////////////////
// configure the range by the range string.
@property(nonatomic, assign) float			range;		// the range value.
@property(nonatomic, readonly) NSDictionary *ranges;	// the range vale map to point.
// set range map by string ,like:@"1-10:100,100|11-20:200,200|30-50:30,300"
- (void)setRangeToPoint:(NSString *)rtp;
// set range map by file.
- (void)setRangeToPointByFile:(NSString *)name type:(NSString *)type;
//////////////////////////////////////////
@end
