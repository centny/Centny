//
//  CnyViewController.m
//  TCny
//
//  Created by Cny on 10/13/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "CnyViewController.h"

@interface CnyViewController ()

@end

@implementation CnyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CnyCMethod test];
    [CnyDownloader test];
    [CnyRequester test];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
