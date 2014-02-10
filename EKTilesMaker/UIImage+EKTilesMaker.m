//
//  UIImage+EKTilesMaker.m
//  EKTilesMakerDemo
//
//  Created by Evgeniy Kirpichenko on 2/8/14.
//  Copyright (c) 2014 Evgeniy Kirpichenko. All rights reserved.
//

#import "UIImage+EKTilesMaker.h"

@implementation UIImage (EKTilesMaker)

+ (UIImage *)imageWithScale:(CGFloat)scale atPath:(NSString *)imagePath
{
    UIImage *sourceImage = [UIImage imageWithContentsOfFile:imagePath];
    UIImage *scaledImage = [sourceImage imageWithScale:scale];
    
    return scaledImage;
}

- (UIImage *)imageWithScale:(CGFloat)scale
{
    CGSize scaledImageSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    
    UIGraphicsBeginImageContext(scaledImageSize);
    
    CGRect drawingRect = CGRectMake(0, 0, scaledImageSize.width, scaledImageSize.height);
    [self drawInRect:drawingRect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)imageInRect:(CGRect)rect
{
    CGImageRef croppedCGImage = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *croppedUIImage = [UIImage imageWithCGImage:croppedCGImage];
    
    CGImageRelease(croppedCGImage);
    
    return croppedUIImage;
}

@end
