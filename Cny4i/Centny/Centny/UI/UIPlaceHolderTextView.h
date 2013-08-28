//
//  UIPlaceHolderTextView.h
//  UIPlaceHolderTextView
//
//  Created by Ren XinWei on 12-11-15.
//  Copyright (c) 2012年 renxinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
{
    NSString *placeHolder;
    UIColor *placeHolderColor;
    
    @private
    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) NSString *placeHolder;
@property (nonatomic, retain) UIColor *placeHolderColor;
@property (nonatomic, retain) UILabel *placeHolderLabel;
- (void)textChanged:(NSNotification *)notification;

@end
