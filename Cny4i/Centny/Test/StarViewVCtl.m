//
//  StarViewVCtl.m
//  Centny
//
//  Created by Centny on 9/11/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "StarViewVCtl.h"
#import "Centny.h"
@interface StarViewVCtl ()

@end

@implementation StarViewVCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    int starcount=5;
    float fh=15;
    UIStarView *star;
    for(starcount=1;starcount<20;starcount++){
        star=[[UIStarView alloc]initWithFrame:CENTER_RECT_H(self.view,10*starcount, fh*starcount+SV_STAR_DIS*(starcount-1), fh) star:(starcount/2) maxStar:starcount];
        star.starImg=[UIImage imageNamed:@"star.png"];
        star.halfStarImg=[UIImage imageNamed:@"half_star.png"];
        star.backStarImg=[UIImage imageNamed:@"gray_star.png"];
        [self.view addSubview:star];
        [star release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
