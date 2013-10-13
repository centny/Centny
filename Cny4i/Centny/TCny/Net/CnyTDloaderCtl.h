//
//  CnyTDloaderCtl.h
//  TCny
//
//  Created by Cny on 10/13/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CnyTDloaderCtl : UIViewController<NSURLConnectionDownloadDelegate>
-(IBAction)clkStart:(id)sender;
-(IBAction)clkStop:(id)sender;
@end
