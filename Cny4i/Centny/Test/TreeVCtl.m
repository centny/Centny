//
//  UITreeVCtl.m
//  UIECommerce
//
//  Created by ShaoHong Wen on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TreeVCtl.h"
#import "Centny.h"
#import "UIPushTreeView.h"
#import "JSONKit.h"
#import "AppDelegate.h"
@interface TreeVCtl (){
    UIView *con;
}
@end

@implementation TreeVCtl
@synthesize type=_type;
-(BOOL)isParentNode:(NSDictionary*)sobj{
    NSDLog(@"%d",[[sobj objectForKey:@"tb_is_parent"]intValue]);
    return [[sobj objectForKey:@"tb_is_parent"]intValue]==1;
}
-(void)onSelectLeaf:(NSDictionary *)row{
    NSDLog(@"select leaf:%@",[row objectForKey:@"tb_cid"]);
}
-(BOOL)onSelectParent:(NSDictionary *)row{
    NSDLog(@"select parent:%@,do nothing",[row objectForKey:@"tb_cid"]);
    return YES;
}
//
-(UIView*)cellView:(NSDictionary *)sobj cell:(UITableViewCell *)cell{
    UILabel *label=[[[UILabel alloc]initWithFrame:CGRectMake(0, 15, 100, 20)]autorelease];
    label.text=[sobj objectForKey:@"tb_name"];
    label.font=[UIFont systemFontOfSize:19];
    return label;
}
-(void)onSubtreeCreated:(UITreeView*)subtree parent:(NSDictionary *)sobj{
    NSString *fileName=[NSString stringWithFormat:@"Child-%@",[sobj objectForKey:@"tb_cid"]];
    NSData *data=FILE_DATA(fileName, @"json");
    NSDictionary *jobj=[data objectFromJSONData];
    [subtree dataWithArray:[jobj objectForKey:@"list"]];
}
-(float)cellHeight{
    return 50;
}
-(float)subIndent{
    return 20;
}
-(UIView*)rowTreeLeftIconView:(NSDictionary*)sobj cell:(UITableViewCell*)cell{
#define IV_H 16
    UITreeIconView *view=[UITreeIconView emptyIconView:CGRectMake(5, 17, IV_H, IV_H)];
    if([self isParentNode:sobj]){
        [view setImage:[UIImage imageNamed:@"closed.png"] status:CELL_CLOSED];
        [view setImage:[UIImage imageNamed:@"opened.png"] status:CELL_OPENED];
        return view;
    }else{
        return view;
    }
}
-(UIView*)rowTreeRightIconView:(NSDictionary*)sobj cell:(UITableViewCell*)cell{
#define IV_H 16
    UITreeIconView *view=[UITreeIconView emptyIconView:CGRectMake(5, 17, IV_H, IV_H)];
    if([self isParentNode:sobj]){
        [view setImage:[UIImage imageNamed:@"closed.png"] status:CELL_CLOSED];
        [view setImage:[UIImage imageNamed:@"opened.png"] status:CELL_OPENED];
        return view;
    }else{
        return view;
    }
}
//
-(UITableViewCell*)createTabelCell:(UITableView*)table row:(NSDictionary*)row ptv:(UIPushTreeView*)ptv{
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if([self isParentNode:row]){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text=[row objectForKey:@"tb_name"];
    return cell;
}
-(void)onCreateSubtree:(UIPushTreeView*)subtree row:(NSDictionary*)row{
    NSString *fileName=[NSString stringWithFormat:@"Child-%@",[row objectForKey:@"tb_cid"]];
    NSData *data=FILE_DATA(fileName, @"json");
    NSDictionary *jobj=[data objectFromJSONData];
    [subtree setData:[jobj objectForKey:@"list"]];
}
//the header view.
-(UIView*)headerView:(NSDictionary*)parent tree:(UIPushTreeView *)tree{
    UILineView *view=[[[UILineView alloc]initWithFrame:CGRectMake(0, 0, FRAM_W(self.view), PTV_HEADER_H)]autorelease];
    view.drawer.lineColor=[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.9];
    view.drawer.lineSize=2;
    [view addBottomLine];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 100, 30)];
    title.backgroundColor=[UIColor clearColor];
    if(parent){
        title.text=[parent objectForKey:@"tb_name"];
    }else{
        title.text=@"商品分类";
    }
    title.textAlignment=UITextAlignmentCenter;
    [view addSubview:title];
    [title release];
    view.backgroundColor=[UIColor whiteColor];
    return view;
}
//the header button.
-(UIButton*)headerBtn:(NSDictionary*) parent tree:(UIPushTreeView *)tree{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, 5,PTV_HEADER_H, PTV_HEADER_H-10);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:12];
    if(tree.parent.parentObj){
        [btn setTitle:[tree.parent.parentObj objectForKey:@"tb_name"] forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"商品分类" forState:UIControlStateNormal];
    }
    return btn;
}
-(void)clkBtn{
    NSDLog(@"clkBtn");
    [con addGestureRecognizer:[UIGestureRecognizer recognizerByClick:self action:@selector(clkRecognizer)]];
}
-(void)clkRecognizer{
    NSDLog(@"clkRecognizer");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    switch (_type) {
        case 1:{
            UITreeView *view=[[UITreeView alloc]initWithFrame:CGRectMake(0, 0, 320, FRAM_H(self.view))];
            view.delegatetvd=self;
            NSData *data=FILE_DATA(@"Parent", @"json");
            NSDictionary *jobj=[data objectFromJSONData];
            [view dataWithArray:[jobj objectForKey:@"list"]];
            [self.view addSubview:view];
            [view release];
        }
            break;
        case 2:{
            UIPushTreeView *pview=[[UIPushTreeView alloc]initWithFrame:CGRectMake(0, 0, 320, FRAM_H(self.view))];
            pview.delegateptvd=self;
            NSData *data=FILE_DATA(@"Parent", @"json");
            NSDictionary *jobj=[data objectFromJSONData];
            [pview setData:[jobj objectForKey:@"list"]];
            [self.view addSubview:pview];
            [pview release];
        }
            break;
        default:{
            con=[[UIView alloc]initWithFrame:self.view.frame];
            con.backgroundColor=[UIColor grayColor];
            UIView *ov=[[UIView alloc]initWithFrame:self.view.frame];
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setTitle:@"Test" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.frame=CGRectMake(10, 10, 100, 30);
            [btn addTarget:self action:@selector(clkBtn) forControlEvents:UIControlEventTouchUpInside];
//            [ov addSubview:btn];
            [con addSubview:btn];
            [self.view addSubview:con];
            [ov release];
        }
            break;
    }
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
-(void)dealloc{
    IF_REL(con);
    [super dealloc];
}
@end
