//
//  ViewController.m
//  Test
//
//  Created by Centny on 9/11/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "ViewController.h"
#import "GeneralDef.h"
#import "NavRootVCtl.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize nav=_nav;
- (void)viewDidLoad
{
    [super viewDidLoad];
    _nav=[[UINavigationController alloc]initWithRootViewController:[[[NavRootVCtl alloc]init]autorelease]];
    _nav.view.frame=CGRectMake(0, 0, 320, 460);
    [self.view addSubview:_nav.view];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
