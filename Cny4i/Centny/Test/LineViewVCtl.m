//
//  LineViewVCtl.m
//  Centny
//
//  Created by Centny on 9/11/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "LineViewVCtl.h"
#import "Centny.h"
@interface LineViewVCtl ()

@end

@implementation LineViewVCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILineView *line;
    line=[[UILineView alloc]initWithFrame:CENTER_RECT_H(self.view, 10, 300, 30)];
    line.backgroundColor=[UIColor whiteColor];
    [line addBottomLine];
    [line addTopLine];
    [line addLeftLine];
    [line addRightLine];
    [line addHCenterLine];
    [line addVCenterLine];
    [self.view addSubview:line];
    [line release];
    //
    line=[[UILineView alloc]initWithFrame:CENTER_RECT_H(self.view, 50, 300, 50)];
    line.backgroundColor=[UIColor whiteColor];
    line.drawer.lineColor=[UIColor redColor];
    line.drawer.lineSize=3;
    [line addBottomLine];
    [line addTopLine];
    [line addLeftLine];
    [line addRightLine];
    [line addHCenterLine];
    [line addVCenterLine];
    [self.view addSubview:line];
    [line release];
    //
    line=[[UILineView alloc]initWithFrame:CENTER_RECT_H(self.view, 110, 300, 50)];
    line.backgroundColor=[UIColor whiteColor];
    line.drawer.lineColor=[UIColor greenColor];
    line.drawer.lineDash=YES;
    line.drawer.lineSize=2;
    [line addBottomLine];
    [line addTopLine];
    [line addLeftLine];
    [line addRightLine];
    [line addHCenterLine];
    [line addVCenterLine];
    [self.view addSubview:line];
    [line release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
