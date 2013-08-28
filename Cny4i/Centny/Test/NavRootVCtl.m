//
//  NavRootVCtl.m
//  Centny
//
//  Created by Centny on 9/11/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "NavRootVCtl.h"
#import "GeneralDef.h"
#import "StarViewVCtl.h"
#import "LineViewVCtl.h"
#import "BoundsImageVCtl.h"
#import "ColorImageVCtl.h"
#import "Centny.h"
#import "WebViewVCtl.h"
#import "TreeVCtl.h"
#import "TableExtVCtl.h"
#import "LeftPushEffectVCtl.h"
#import "CellAnimationVCtl.h"
@interface NavRootVCtl ()

@end

@implementation NavRootVCtl
-(void)pushClass:(Class)cls{
    UIViewController *vctl=[[cls alloc]init];
    vctl.view.frame=self.view.frame;
    [self.navigationController pushViewController:vctl animated:YES];
    [vctl release];
}
-(void)testStarView{
    [self pushClass:[StarViewVCtl class]];
}
-(void)testLineView{
    [self pushClass:[LineViewVCtl class]];
}
-(void)testBoundsImage{
    [self pushClass:[BoundsImageVCtl class]];
}
-(void)testColorImage{
    [self pushClass:[ColorImageVCtl class]];
}
-(void)testWebView{
    [self pushClass:[WebViewVCtl class]];
}
-(void)testNormalTree:(id)sender{
    TreeVCtl *cvct=[[TreeVCtl alloc]init];
    cvct.type=1;
    [self.navigationController pushViewController:cvct animated:YES];
    [cvct release];
}
-(void)testPushTree:(id)sender{
    TreeVCtl *cvct=[[TreeVCtl alloc]init];
    cvct.type=2;
    [self.navigationController pushViewController:cvct animated:YES];
    [cvct release];
}
-(void)testRecognizer:(id)sender{
    TreeVCtl *cvct=[[TreeVCtl alloc]init];
    cvct.type=100;
    [self.navigationController pushViewController:cvct animated:YES];
    [cvct release];
}
-(void)testTabelExt:(id)sender{
    TableExtVCtl *cvct=[[TableExtVCtl alloc]init];
    [self.navigationController pushViewController:cvct animated:YES];
    [cvct release];
}
-(void)testLPE:(id)sender{
    LeftPushEffectVCtl *cvct=[[LeftPushEffectVCtl alloc]init];
    [self.navigationController pushViewController:cvct animated:YES];
    [cvct release];
}
-(void)testCAV:(id)sender{
    CellAnimationVCtl *cvct=[[CellAnimationVCtl alloc]init];
    [self.navigationController pushViewController:cvct animated:YES];
    [cvct release];
}
-(void)loadView{
    UIScrollView *_sv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    _sv.contentSize=CGSizeMake(320, 600);
    self.view=_sv;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Test";
    UIButton *btn;
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((FRAM_W(self.view)-200)/2, 10, 200, 30);
    [btn setTitle:@"Star View" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testStarView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((FRAM_W(self.view)-200)/2, 50, 200, 30);
    [btn setTitle:@"Line View" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testLineView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((FRAM_W(self.view)-200)/2, 90, 200, 30);
    [btn setTitle:@"Bounds Image View" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testBoundsImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((FRAM_W(self.view)-200)/2, 130, 200, 30);
    [btn setTitle:@"Color Image View" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testColorImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((FRAM_W(self.view)-200)/2, 170, 200, 30);
    [btn setTitle:@"Web View" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((FRAM_W(self.view)-200)/2, 210, 200, 30);
    [btn setTitle:@"Normal Tree" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testNormalTree:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((FRAM_W(self.view)-200)/2, 250, 200, 30);
    [btn setTitle:@"Push Tree" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testPushTree:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((FRAM_W(self.view)-200)/2, 290, 200, 30);
    [btn setTitle:@"Recognizer" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testRecognizer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((FRAM_W(self.view)-200)/2, 330, 200, 30);
    [btn setTitle:@"Table Ext" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testTabelExt:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((FRAM_W(self.view)-200)/2, 370, 200, 30);
    [btn setTitle:@"LPE" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testLPE:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((FRAM_W(self.view)-200)/2, 410, 200, 30);
    [btn setTitle:@"CAV" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testCAV:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
