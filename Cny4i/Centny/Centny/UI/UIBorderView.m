//
//  UIBorderView.m
//  Centny
//
//  Created by Centny on 4/9/13.
//  Copyright (c) 2013 Centny. All rights reserved.
//

#import "UIBorderView.h"
#import <QuartzCore/QuartzCore.h>
#import "ClassExt.h"

@implementation UIBorderView
@synthesize borderColor,borderWidth,cornerRadius;
-(void)setBorderColor:(UIColor *)borderColor_{
    [self.layer setBorderColor:[borderColor_ CGColor]];
}
-(void)setBorderWidth:(float)borderWidth_{
    [self.layer setBorderWidth:borderWidth_];
}
-(void)setCornerRadius:(float)cornerRadius_{
    [self.layer setCornerRadius:cornerRadius_];
}
-(void)setValue:(id)value forKeyPath:(NSString *)keyPath{
    if([@"borderColor" isEqualToString:keyPath]){
        if([value isKindOfClass:[UIColor class]]){
            self.borderColor=value;
        }else{
            self.borderColor=[UIColor colorWithString:value];
        }
    }else if([@"borderWidth" isEqualToString:keyPath]){
        self.borderWidth=[value floatValue];
    }else if([@"cornerRadius" isEqualToString:keyPath]){
        self.cornerRadius=[value floatValue];
    }
    else{
        [super setValue:value forKeyPath:keyPath];
    }
}
-(void)dealloc{
    self.borderColor=nil;
    [super dealloc];
}
@end
