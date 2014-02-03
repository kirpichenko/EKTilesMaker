//
//  EKTileMaker.m
//  EKTilesMakerDemo
//
//  Created by Evgeniy Kirpichenko on 2/3/14.
//  Copyright (c) 2014 Evgeniy Kirpichenko. All rights reserved.
//

#import "EKTilesMaker.h"

static NSUInteger const kDefaultTileWidth = 256;
static NSUInteger const kDefaultTileHeight = 256;
static CGFloat const kDefaultScale = 1.f;

@implementation EKTilesMaker

- (id)init
{
    if (self = [super init]) {
        [self setScaleSizes:@[@(kDefaultScale)]];
        [self setTileSize:CGSizeMake(kDefaultTileWidth, kDefaultTileHeight)];
        [self setOutputFileType:OutputFileTypePNG];
    }
    return self;
}

- (void)createTiles
{
    [self prepareOutputFolder];
    
    for (NSNumber *scale in [self scaleSizes]) {
        [self createTilesOfSize:self.tileSize sourceImageScale:[scale floatValue]];
    }
}

- (void)validateInitialParams
{
    if (self.sourceImage == nil) {
        [NSException raise:@"Exception" format:@"Source image isn't specified"];
    }
}

#pragma mark - private

- (void)createTilesOfSize:(CGSize)tilesSize sourceImageScale:(CGFloat)scale
{
    NSInteger row = 0;
    NSInteger column = 0;
    
    UIImage *sourceImage = [self scaledSourceImage:scale];
    
    CGRect tileFrame = CGRectMake(0, 0, tilesSize.width, tilesSize.height);
    while (tileFrame.origin.x < sourceImage.size.width) {
        while (tileFrame.origin.y < sourceImage.size.height) {
            UIImage *tile = [self cropImageWithFrame:tileFrame source:sourceImage];
            NSString *tileName = [self tileNameWithScale:scale row:row column:column];
            
            [self storeImage:tile name:tileName];
            
            tileFrame.origin.y += tilesSize.height;
            row += 1;
        }
        tileFrame.origin.x += tilesSize.width;
        column += 1;
        
        tileFrame.origin.y = 0;
        row = 0;
    }
}

- (UIImage *)scaledSourceImage:(CGFloat)scale
{
    CGSize imageSize = self.sourceImage.size;
    CGSize scaledImageSize = CGSizeMake(imageSize.width * scale, imageSize.height * scale);

    UIGraphicsBeginImageContext(scaledImageSize);
    
    [self.sourceImage drawInRect:CGRectMake(0, 0, scaledImageSize.width, scaledImageSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)cropImageWithFrame:(CGRect)tileFrame source:(UIImage *)sourceImage
{
    CGImageRef tileCGImage = CGImageCreateWithImageInRect([sourceImage CGImage], tileFrame);
    UIImage *tileImage = [UIImage imageWithCGImage:tileCGImage];
    
    CGImageRelease(tileCGImage);
    
    return tileImage;
}

- (NSString *)tileNameWithScale:(CGFloat)scale row:(NSUInteger)row column:(NSUInteger)column
{
    NSString *fileExtension = (self.outputFileType == OutputFileTypePNG) ? @"png" : @"jpg";
    NSString *fileName = [NSString stringWithFormat:@"%@_%d_%d_%d.%@",
                          self.outputFileName,
                          (int)(scale * 1000),
                          row,
                          column,
                          fileExtension];
    return fileName;
}

- (void)storeImage:(UIImage *)image name:(NSString *)fileName
{
    NSError *error;
    NSData *imageData;
    if (self.outputFileType == OutputFileTypePNG) {
        imageData = UIImagePNGRepresentation(image);
    }
    else {
        imageData = UIImageJPEGRepresentation(image, 1.);
    }
    
    NSString *filePath = [self.outputFolderPath stringByAppendingPathComponent:fileName];
    BOOL written = [imageData writeToFile:filePath options:NSDataWritingFileProtectionNone error:&error];
    if (!written) {
        NSLog(@"Tile storing error: %@", [error description]);
    }
}

- (void)prepareOutputFolder
{
    NSAssert(self.outputFolderPath, @"Output folder should be specified by user");
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.outputFolderPath]) {
        [fileManager createDirectoryAtPath:self.outputFolderPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
}


@end
