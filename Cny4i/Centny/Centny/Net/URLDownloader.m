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
-(id)init{
    self=[super init];
    if(self){
        self.clength=self.tlength=0;
    }
    return self;
}
-(float)trate{
    if(self.clength<1){
        return 0;
    }else{
        return ((double)self.tlength)/((double)self.clength);
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [super connection:connection didReceiveResponse:response];
    NSString* cl=[self.resHeaders objectForKey:@"Content-Length"];
    if(cl&&cl.length){
        self.clength=atol([cl UTF8String]);
    }else{
        self.clength=0;
    }
    self.tlength=0;
    if(self.clength&&self.dldelegate&&[self.dldelegate respondsToSelector:@selector(onDownloaderRate:trate:)]){
        [self.dldelegate onDownloaderRate:self trate:self.trate];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.tlength+=data.length;
    if(self.dldelegate&&[self.dldelegate respondsToSelector:@selector(onDownloaderReceive:received:total:)]){
        [self.dldelegate onDownloaderReceive:self received:self.tlength total:self.clength];
    }
    if(self.clength&&self.dldelegate&&[self.dldelegate respondsToSelector:@selector(onDownloaderRate:trate:)]){
        [self.dldelegate onDownloaderRate:self trate:self.trate];
    }
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
