//
//  URLDownloader.m
//  ALearning
//
//  Created by Cny on 10/6/13.
//  Copyright (c) 2013 Scorpion. All rights reserved.
//

#import "URLDownloader.h"
@interface URLDownloader()
@property(nonatomic)NSOutputStream *output;
@end
static BOOL __dllog=NO;
@implementation URLDownloader

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.output write:data.bytes maxLength:data.length];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.output close];
    self.output=nil;
    [super connectionDidFinishLoading:connection];
    if(__dllog){
        NSLog(@"down file success to:%@",self.spath);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.output close];
    self.output=nil;
    NSFileManager *fm=[NSFileManager defaultManager];
    [fm removeItemAtPath:self.spath error:nil];
    [super connection:connection didFailWithError:error];
    if(__dllog){
        NSLog(@"down file error to:%@",self.spath);
    }
}
-(void)start{
    if(self.spath==nil||[self.spath isEmptyOrWhiteSpace]){
        if(self.completed){
            self.completed(self,@"save path not setting.");
        }
        return;
    }
    self.output=[NSOutputStream outputStreamToFileAtPath:self.spath append:NO];
    if(self.output==nil){
        if(self.completed){
            self.completed(self,@"open save path error.");
        }
        return;
    }
    [self.output open];
    if(__dllog){
        NSLog(@"start down file to:%@",self.spath);
    }
    [super start];
}
+(void)showLog:(BOOL)log{
    __dllog=log;
}
@end
