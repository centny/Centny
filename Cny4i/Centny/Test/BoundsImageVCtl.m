//
//  BoundsImageVCtl.m
//  Centny
//
//  Created by Centny on 9/12/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "BoundsImageVCtl.h"
#import "UIBoundsImageView.h"

@interface BoundsImageVCtl ()

@end

@implementation BoundsImageVCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBoundsImageView *img,*src;
    src=[[UIBoundsImageView alloc]initWithFrame:CGRectMake(100, 30, 80, 16)];
    src.image=[UIImage imageNamed:@"taobaolevel.png"];
    src.backgroundColor=[UIColor whiteColor];
    [src setRangeToPointByFile:@"taobaolevel" type:@"txt"];
    src.range=5;
    int idx=0;
    for(NSPart *p in [src.ranges allKeys]){
        img=[[UIBoundsImageView alloc]initWithFrame:CGRectMake(100, 30*idx, 80, 16)];
        img.image=[UIImage imageNamed:@"taobaolevel.png"];
        img.backgroundColor=[UIColor whiteColor];
        [img setRangeToPointByFile:@"taobaolevel" type:@"txt"];
        img.range=[p.one floatValue]+5;
        idx++;
        [self.view addSubview:img];
        [img release];
    }
    [src release];
}
-(void)loadView{
    UIScrollView *sv=[[[UIScrollView alloc]init]autorelease];
    sv.frame=CGRectMake(0, 0, 320, 411);
    sv.contentSize=CGSizeMake(320, 1000);
    self.view=sv;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
