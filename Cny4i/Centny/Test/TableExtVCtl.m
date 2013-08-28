//
//  TableExtVCtl.m
//  Centny
//
//  Created by Centny on 9/24/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "TableExtVCtl.h"
#import "UITableExtView.h"
@interface TableExtVCtl ()

@end

@implementation TableExtVCtl
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [@"Cell" stringByAppendingFormat:@"-%d",indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.textLabel.text=@"test";
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(BOOL)isNeedRefresh:(UITableExtView *)tableview{
    return YES;
}
-(void)onRefresh:(UITableExtView *)tableview{
    [tableview performSelector:@selector(reloadData) withObject:nil afterDelay:3];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUseRelLog(1);
    UITableExtView *tev=[[UITableExtView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
    tev.tdelegate=self;
    tev.dataSource=self;
    [self.view addSubview:tev];
    [tev release];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
