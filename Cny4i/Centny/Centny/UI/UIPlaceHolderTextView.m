//
//  UIPlaceHolderTextView.m
//  UIPlaceHolderTextView
//
//  Created by Ren XinWei on 12-11-15.
//  Copyright (c) 2012年 renxinwei. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView

@synthesize placeHolder;
@synthesize placeHolderColor;
@synthesize placeHolderLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setPlaceHolder:@""];
        [self setPlaceHolderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setPlaceHolder:@""];
    [self setPlaceHolderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)drawRect:(CGRect)rect
{
    if ([[self placeHolder] length] > 0) {
        if (placeHolderLabel == nil) {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
        
        placeHolderLabel.text = self.placeHolder;
        placeHolderLabel.textColor = self.placeHolderColor;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if ([[self text] length] == 0 && [[self placeHolder] length] > 0) {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
    
#else
    [placeHolderLabel release];
    placeHolderLabel = nil;
    [placeHolderColor release];
    placeHolderColor = nil;
    [placeHolder release];
    placeHolder = nil;
    [super dealloc];
#endif
}
-(void)setText:(NSString *)text

{
    [super setText:text];
    [self textChanged:nil];
}

- (void)textChanged:(NSNotification *)notification
{
    if ([[self placeHolder] length] == 0) {
        return;
    }
    if ([[self text] length] == 0) {
        [[self viewWithTag:999] setAlpha:1];
    }
    else {
        [[self viewWithTag:999] setAlpha:0];
    }
}


@end


