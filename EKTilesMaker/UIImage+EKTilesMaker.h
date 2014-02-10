//
//  UIImage+Transforming.h
//  EKTilesMakerDemo
//
//  Created by Evgeniy Kirpichenko on 2/8/14.
//  Copyright (c) 2014 Evgeniy Kirpichenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EKTilesMaker)

+ (UIImage *)imageWithScale:(CGFloat)scale atPath:(NSString *)imagePath;

- (UIImage *)imageWithScale:(CGFloat)scale;
- (UIImage *)imageInRect:(CGRect)rect;

@end
