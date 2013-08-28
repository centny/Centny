//
//  LeftPushEffectVCtl.m
//  Centny
//
//  Created by Wen ShaoHong on 10/8/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "LeftPushEffectVCtl.h"

@interface LeftPushEffectVCtl (){
    UIView *_lview;
    UIView *_content;
    UIView *_oview;
}

@end

@implementation LeftPushEffectVCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)clkOBack{
    [UIView animateWithDuration:0.5 animations:^{
        _oview.frame=CGRectMake(320, 0, 320, 460);
    } completion:^(BOOL f){
        [_oview removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            _content.frame=CGRectMake(FRAM_W(_lview), 0, 320, 460);
        } completion:^(BOOL f){
            
        }];
    }];
}
-(void)clkOther{
    IF_REL(_oview);
    _oview=[[UIView alloc]initWithFrame:CGRectMake(320, 0, 320, 460)];
    _oview.backgroundColor=[UIColor greenColor];
    UIButton *btn;
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(110, 0, 100, 40);
    [btn setTitle:@"Back" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clkOBack) forControlEvents:UIControlEventTouchUpInside];
    [_oview addSubview:btn];
    [self.view addSubview:_oview];
    [UIView animateWithDuration:0.5 animations:^{
        _content.frame=CGRectMake(320, 0, 320, 460);
    } completion:^(BOOL f){
        [UIView animateWithDuration:0.5 animations:^{
            _oview.frame=CGRectMake(0, 0, 320, 460);
        } completion:^(BOOL f){
            
        }];
    }];
}
-(void)clkBack{
    [UIView popLView:_content lv:_lview finished:0];
}
-(void)clkLeft{
    IF_REL(_lview);
    _lview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 460)];
    _lview.backgroundColor=[UIColor whiteColor];
    UIButton *btn;
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(50, 0, 100, 40);
    [btn setTitle:@"Other" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clkOther) forControlEvents:UIControlEventTouchUpInside];
    [_lview addSubview:btn];
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(50, 50, 100, 40);
    [btn setTitle:@"Back" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clkBack) forControlEvents:UIControlEventTouchUpInside];
    [_lview addSubview:btn];
    [self.view addSubview:_lview];
    [UIView pushLView:_content lv:_lview finished:0];
}
-(void)loadView{
    [super loadView];
    UIButton *btn;
    _content=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    _content.backgroundColor=[UIColor grayColor];
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(110, 0, 100, 40);
    [btn setTitle:@"Left" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clkLeft) forControlEvents:UIControlEventTouchUpInside];
    [_content addSubview:btn];
    [self.view addSubview:_content];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
