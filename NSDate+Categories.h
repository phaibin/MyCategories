//
//  NSDate+Categories.h
//  DDCoupon
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Categories)

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format; 
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
- (NSString *)normalizeDateString;

@end
