//
//  ClassExt.h
//  Centny
//
//  this header contain some class extend define.
//
//  Created by Centny on 9/10/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

// #ifndef Centny_ClassExt_h
// #define Centny_ClassExt_h
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//
@class NSGImage;
/**
 *    the extend method for NSString.
 *    @author Centny
 *    @since 1.0.0
 */
@interface NSString (PatternStringToNSDictionary)

/**
 *    convert the string to dictionary by two speparator,like a=1&b=2.
 *    @param separator target array separator,like ,./
 *    @param kvs the key value separator,like ,./.can't the same as the array separator.
 *    @returns return the autorelease dictionary instance.
 */
- (id)dictionaryBy:(NSString *)separator kvSeparator:(NSString *)kvs;

/**
 *    convert the string to dictionary by URL query string.like URL http://www.baidu.com/s?a=2&b=2 query string is a=2&b=2.
 *    it is meaning separate the query by & array separator and = key value separator.
 *    @returns return the autorelease dictionary instance.
 */
- (id)dictionaryByURLQuery;
//

/**
 *    count the real height for the target string by the show width and font size.
 *    @param width the width will be showed.
 *    @param font  the font size will be showed.
 *    @returns the real height.
 */
- (float)heightByLineWidth:(float)width font:(UIFont *)font;
//

/**
 *    check the string whether empty or white space.
 *    @returns empty or white space return YES,or NO.
 */
- (BOOL)isEmptyOrWhiteSpace;
@end

/**
 *    the extend method for NSDoctionary.
 *    @author Centny
 *    @since 1.0.0
 */
@interface NSDictionary (PatternStringToNSDictionary)

/**
 *    convert the string to dictionary by two speparator string,like @"a=1&b=2".
 *    @param data target string.
 *    @param arys array separator.
 *    @param kvs key value separator.
 *    @returns return the autorelease dictionary instance.
 */
+ (id)dictionaryBy:(NSString *)data arySeparator:(NSString *)arys kvSeparator:(NSString *)kvs;

/**
 *    convert the dictionary to URL query.
 *    @returns the URL query.
 */
- (id)stringByURLQuery;
@end

/**
 *    the extend method for  NSURL.
 *    @author Centny
 *    @since 1.0.0
 */
@interface NSURL (URLQueryStringToNSDictionary)

/**
 *    convert the NSURL.query to dictionary.
 *    @returns return the autorelease dictionary instance.
 */
- (id)dictionaryByURLQuery;
@end

/**
 *    the extend method for NSURLRequest.
 *    @author Centny
 *    @since 1.0.0
 */
@interface NSURLRequest (URLQueryStringToNSDictionary)

/**
 *    convert NSURLRequest.URL.query to dictionary.
 *    @returns return the autorelease dictionary instance.
 */
- (id)dictionaryByURLQuery;
@end

/**
 *    the extend method for UIColor.
 *    @author Centny
 *    @since 1.0.0
 */
@interface UIColor (Color2Image)

/**
 *    create the 1pix image by color.
 *    @returns the 1x1 image.
 */
- (UIImage *)image;
+ (UIColor *)colorWithR:(int)r G:(int)g B:(int)b A:(float)a;
@end

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////UIImage////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
// the image extensions.
@interface UIImage (Extensions)
// create image by color.
+ (UIImage *)imageWithColor:(UIColor *)color;
- (NSGImage *)gimage;
- (UIImage *)convertToGreyscale;
@end

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////UIView////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIView (ExtendView)
// push  view to right.
+ (void)pushRView:(UIView *)left rv:(UIView *)rv finished:(void (^)(BOOL finished))finished;
// pop the right view.
+ (void)popRView:(UIView *)left rv:(UIView *)rv finished:(void (^)(BOOL finished))finished;
// push  view to left.
+ (void)pushLView:(UIView *)right lv:(UIView *)lv finished:(void (^)(BOOL finished))finished;
// pop the left view.
+ (void)popLView:(UIView *)right lv:(UIView *)lv finished:(void (^)(BOOL finished))finished;
///////////////////////////////////////////////
// check and updae the dispaly postion to int.
+ (void)reviseTextDisplay:(UIView *)view;
+ (CGRect)reviseViewFrame:(CGRect)rect;
+ (int)checkIsInt:(CGFloat)arg;
+ (int)checkIsEven:(CGFloat)arg;
//////////////////////////////////////////////
// create the color view.
+ (id)viewWithColor:(UIColor *)color frame:(CGRect)frame;
@end
////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////UIGestureRecognizer./////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIGestureRecognizer (ClickRecognizer)
+ (UITapGestureRecognizer *)recognizerByClick:(id)owner action:(SEL)action;
+ (UITapGestureRecognizer *)recognizerByDoubleClick:(id)owner action:(SEL)action;
@end
////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////UIScreen./////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIScreen (Vesion)
+ (BOOL)isIPhone5;
+ (float)contentHeight;
@end
////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////UIDevice./////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//
@interface UIColor (String)
+ (id)colorWithString:(NSString *)hex;
@end
// #endif	/* ifndef Centny_ClassExt_h */

