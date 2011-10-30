//
//  UImage+Categories.h
//  DDCheckin
//
//  Created by Leon on 11-7-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (UImage_Categories)

+ (UIImage*)reviseImage:(UIImage *)sourceImage;
- (UIImage *)limitToSize:(CGSize)size;
- (UIImage *)clipToSize:(CGSize)size;
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)centerToSize:(CGSize)size;

@end
