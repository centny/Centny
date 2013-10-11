//
//  UIBorderView.h
//  Centny
//
//  Created by Centny on 4/9/13.
//  Copyright (c) 2013 Centny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBorderView : UIView
@property(nonatomic) float				cornerRadius;
@property(nonatomic) float				borderWidth;
@property(nonatomic, retain) UIColor	*borderColor;
@end
