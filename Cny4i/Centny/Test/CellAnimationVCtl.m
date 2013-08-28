//
//  CellAnimationVCtl.m
//  Centny
//
//  Created by Wen ShaoHong on 10/8/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//
#import "Centny.h"
#import "CellAnimationVCtl.h"

@interface UIDView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UIView *_bview;
    UITableView *_tv;
    CGRect ort;
}
-(void)beginAnimation;
@end

@implementation UIDView
-(void)clkBack{
    [UIView animateWithDuration:0.3 animations:^{
        _tv.frame=CGRectMake(0,50, FRAM_W(_tv),0);
        _bview.frame=CGRectMake(0, 460, FRAM_W(_bview), FRAM_H(_bview));
    } completion:^(BOOL f){
        [UIView animateWithDuration:0.3 animations:^{
            self.frame=CGRectMake(ort.origin.x, ort.origin.y, ort.size.width, 0);
        } completion:^(BOOL fi){
            [self removeFromSuperview];
        }];
    }];
}
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        UILineView *_header=[[UILineView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        _header.backgroundColor=[UIColor whiteColor];
        _header.drawer.lineSize=2;
        _header.drawer.lineColor=[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.8];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 9, 100, 32)];
        label.text=@"Test";
        label.font=[UIFont systemFontOfSize:20];
        label.backgroundColor=[UIColor clearColor];
        [_header addSubview:label];
        [_header addBottomLine];
        [label release];
        [self addSubview:_header];
        [_header release];
        _tv=[[UITableView alloc]initWithFrame:CGRectMake(0,50, FRAM_W(self), 0)];
        _tv.dataSource=self;
        _tv.delegate=self;
        [self addSubview:_tv];
        _bview=[[UIView alloc]initWithFrame:CGRectMake(0, FRAM_H(self), FRAM_W(self), 45)];
        _bview.backgroundColor=[UIColor grayColor];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:@"Back" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clkBack) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(110, 2, 100, 40);
        [_bview addSubview:btn];
        [self addSubview:_bview];
        self.clipsToBounds=YES;
    }
    return self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[[UITableViewCell alloc]init]autorelease];
    cell.textLabel.text=@"tt@";
    cell.textLabel.font=[UIFont systemFontOfSize:20];
    return cell;
}
-(void)beginAnimation{
    ort=self.frame;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame=CGRectMake(0, 0, 320, 460);
    } completion:^(BOOL f){
        [UIView animateWithDuration:0.3 animations:^{
            _tv.frame=CGRectMake(0,50, FRAM_W(_tv), 325);
            _bview.frame=CGRectMake(0, 375, FRAM_W(_bview), FRAM_H(_bview));
        }];
    }];
}
@end


@interface CellAnimationVCtl ()

@end


@implementation CellAnimationVCtl
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[[UITableViewCell alloc]init]autorelease];
    cell.textLabel.text=@"Test";
    cell.textLabel.font=[UIFont systemFontOfSize:20];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIDView *v=[[[UIDView alloc]initWithFrame:CGRectMake(0, indexPath.row*50, 320, 460)]autorelease];
    v.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:v];
    [v beginAnimation];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView *tv=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    tv.dataSource=self;
    tv.delegate=self;
    [self.view addSubview:tv];
    [tv release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
