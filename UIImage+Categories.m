//
//  UImage+Categories.m
//  DDCheckin
//
//  Created by Leon on 11-7-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Categories.h"

@implementation UIImage (UImage_Categories)

static inline double radians (double degrees) {return degrees * M_PI/180;}

//fix image orientation
+ (UIImage*)reviseImage:(UIImage *)sourceImage
{
    CGFloat targetX = 0;
    CGFloat targetY = 0;
    CGFloat targetWidth = sourceImage.size.width;
    CGFloat targetHeight = sourceImage.size.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    CGContextSetFillColorWithColor(bitmap, [UIColor whiteColor].CGColor);
    CGContextFillRect(bitmap, CGRectMake(0, 0, targetWidth, targetHeight));
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextTranslateCTM (bitmap, targetX, targetY);
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetWidth);
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetHeight, targetWidth), imageRef);
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextTranslateCTM (bitmap, targetX, targetY);
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetHeight, 0);
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetHeight, targetWidth), imageRef);
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
        CGContextTranslateCTM (bitmap, targetX, targetY);
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetX, targetY);
        CGContextRotateCTM (bitmap, radians(-180));
        CGContextTranslateCTM (bitmap, -targetWidth, -targetHeight);
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    }
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];

    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage; 
}

// limit the image to less than size
- (UIImage *)limitToSize:(CGSize)size
{
    if (self.size.width > size.width || self.size.height > size.height) {
        CGFloat targetWidth;
        CGFloat targetHeight;
        CGFloat imageWidth = self.size.width;
        CGFloat imageHeight = self.size.height;
        float rateA = size.width / size.height;
        float rateB = imageWidth / imageHeight;
        if (rateA == rateB) {
            return [self scaleToSize:size];
        } else {
            if (rateA < rateB) {
                targetWidth = imageWidth;
                targetHeight = targetWidth / rateB;
            } else {
                targetHeight = imageHeight;
                targetWidth = targetHeight * rateB;
            }
            return [self scaleToSize:CGSizeMake(targetWidth, targetHeight)];
        }
    } else {
        return self;
    }
}

// clip the center to fit size
- (UIImage *)clipToSize:(CGSize)size
{
    CGFloat targetX = 0;
    CGFloat targetY = 0;
    CGFloat targetWidth;
    CGFloat targetHeight;
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    
    float rateA = size.width / size.height;
    float rateB = imageWidth / imageHeight;
    if (rateA == rateB) {
        return [self scaleToSize:size];
    } else {
        if (rateA < rateB) {
            targetHeight = imageHeight;
            targetWidth = targetHeight * rateA;
            targetX = (targetWidth - imageWidth) / 2;
            targetY = 0;
        } else {
            targetWidth = imageWidth;
            targetHeight = targetWidth / rateA;
            targetX = 0;
            targetY = (targetHeight - imageHeight) / 2;
        }
        
        CGImageRef imageRef = [self CGImage];
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
        
        if (bitmapInfo == kCGImageAlphaNone) {
            bitmapInfo = kCGImageAlphaNoneSkipLast;
        }
        
        CGContextRef bitmap;
        
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        CGContextSetFillColorWithColor(bitmap, [UIColor whiteColor].CGColor);
        CGContextFillRect(bitmap, CGRectMake(0, 0, targetWidth, targetHeight));
        
        // NOTHING
        CGContextTranslateCTM (bitmap, targetX, targetY);
        CGContextDrawImage(bitmap, CGRectMake(0, 0, imageWidth, imageHeight), imageRef);
        CGImageRef ref = CGBitmapContextCreateImage(bitmap);
        UIImage *newImage = [UIImage imageWithCGImage:ref];
        
        UIImage *scaledImage = [newImage scaleToSize:size];
        
        CGContextRelease(bitmap);
        CGImageRelease(ref);
        
        return scaledImage;
    }
}


// put the image in the center of the size
- (UIImage *)centerToSize:(CGSize)size
{
    CGFloat targetX = 0;
    CGFloat targetY = 0;
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    
    targetX = (size.width - imageWidth) / 2;
    targetY = (size.height - imageHeight) / 2;
    
    CGImageRef imageRef = [self CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = (((size_t)size.width * 4) + 0x0000000F) & ~0x0000000F; // 16 byte aligned is good
    bitmap = CGBitmapContextCreate(NULL, size.width, size.height, bitsPerComponent, bytesPerRow, colorSpaceInfo, bitmapInfo);
    CGContextSetFillColorWithColor(bitmap, [UIColor whiteColor].CGColor);
    CGContextFillRect(bitmap, CGRectMake(0, 0, size.width, size.height));
    
    CGContextDrawImage(bitmap, CGRectMake(targetX, targetY, imageWidth, imageHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

- (UIImage *)scaleToSize:(CGSize)size
{  
    if (self.size.width == size.width && self.size.height == size.height)
        return self;
    else {
        // 把它设置成为当前正在使用的context  
        UIGraphicsBeginImageContext(size);  
        // 绘制改变大小的图片  
        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];  
        // 从当前context中创建一个改变大小后的图片  
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
        // 使当前的context出堆栈  
        UIGraphicsEndImageContext();  
        // 返回新的改变大小后的图片  
        
//        NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
//        [UIImagePNGRepresentation(scaledImage) writeToFile:pngPath atomically:YES];
        
        return scaledImage;  
    }
}

@end
