//
//  UIStarView.h
//  Centny
//
//  Created by Centny on 7/3/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SV_STAR_DIS 3
// the star view.
// the star size is the view frame height.
@interface UIStarView : UIView
						//
- (id)initWithFrame:(CGRect)frame star:(float)star maxStar:(int)max;
// the start image.
- (void)initStar:(float)star maxStar:(int)max;
@property(nonatomic) int						w_h;
@property(nonatomic, retain) IBOutlet UIImage	*starImg;
@property(nonatomic, retain) IBOutlet UIImage	*halfStarImg;
@property(nonatomic, retain) IBOutlet UIImage	*backStarImg;
@end
