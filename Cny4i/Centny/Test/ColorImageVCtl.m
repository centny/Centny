//
//  ColorImageVCtl.m
//  Centny
//
//  Created by Centny on 9/14/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "ColorImageVCtl.h"
#import "Centny.h"
@interface ColorImageVCtl ()

@end

@implementation ColorImageVCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    NSGImage *gimg=[NSGImage gimageNamed:@"test_color.png"];
    for(int y=0;y<gimg.height;y++){
        for(int x=0;x<gimg.width;x++){
            printf("%d\t",[gimg valueAt:x y:y a:0]);
            printf("%d\t",[gimg valueAt:x y:y a:1]);
            printf("%d\t",[gimg valueAt:x y:y a:2]);
        }
        printf("\n");
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
