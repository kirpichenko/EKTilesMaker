//
//  UIImage+Transforming.h
//  EKTilesMakerDemo
//
//  Created by Evgeniy Kirpichenko on 2/8/14.
//  Copyright (c) 2014 Evgeniy Kirpichenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EKTilesMaker)

/*! Gets image at path and scales it to provided scale
 \param scale Scaling value for image
 \param imagePath Path for source image
 \returns Scaled image at path
 */
+ (UIImage *)imageWithScale:(CGFloat)scale atPath:(NSString *)imagePath;


/*! Scales image to provided scale
 \param scale Scaling value to be applied to the original image
 \returns Sclaed original image
 */
- (UIImage *)imageWithScale:(CGFloat)scale;


/*! Extracts image in rect from original image
 \param rect Rectangle to be used for image cropping
 \returns Image cropped from original with provided rectangle
 */
- (UIImage *)imageInRect:(CGRect)rect;

@end
