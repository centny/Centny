//
//  NSGImage.h
//  Centny
//
//  Created by Centny on 9/14/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// the RGBA image.
@interface NSGImage : NSObject {
	unsigned char	*_rawData;
	size_t			_width;
	size_t			_height;
}
@property(nonatomic, readonly) unsigned char	*rawData;
@property(nonatomic, readonly) size_t			width;
@property(nonatomic, readonly) size_t			height;
- (id)initWith:(UIImage *)image;
- (UIColor *)colorAt:(size_t)x y:(size_t)y;
- (void)colorAt:(unsigned char *)buf x:(size_t)x y:(size_t)y;
- (unsigned char *)rawDataAt:(size_t)x y:(size_t)y;
- (unsigned char)valueAt:(size_t)x y:(size_t)y a:(size_t)a;
+ (id)gimageWith:(UIImage *)image;
+ (id)gimageNamed:(NSString *)name;
@end
