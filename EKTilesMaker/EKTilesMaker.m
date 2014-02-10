//
//  EKTileMaker.m
//  EKTilesMakerDemo
//
//  Created by Evgeniy Kirpichenko on 2/3/14.
//  Copyright (c) 2014 Evgeniy Kirpichenko. All rights reserved.
//

#import "EKTilesMaker.h"

#import "UIImage+EKTilesMaker.h"

@interface EKTilesMaker ()
@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic) dispatch_group_t group;
@end

@implementation EKTilesMaker

#pragma mark - life cycle

- (id)init
{
    if (self = [super init]) {
        [self setOutputFileType:OutputFileTypePNG];
        [self setZoomLevels:@[@1]];
        
        [self setQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        [self setGroup:dispatch_group_create()];
    }
    return self;
}

#pragma mark - public

- (void)createTiles
{
    NSAssert(self.tileSize.width > 0 && self.tileSize.height > 0, @"Invalid tile size was specified");
    
    dispatch_async(self.queue, ^{
        [self prepareOutputFolder];
        
        for (NSNumber *zoomLevel in [self zoomLevels]) {
            [self createTilesForZoomLevel:[zoomLevel floatValue]];
        }
        
        if (self.completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionBlock();
            });
        }
    });
}

#pragma mark - private

- (void)createTilesForZoomLevel:(CGFloat)zoom
{
    NSAssert(self.sourceImagePath, @"Source image path should be specified by the user");
    UIImage *sourceImage = [UIImage imageWithScale:zoom atPath:self.sourceImagePath];
    
    NSUInteger column = 0;
    CGFloat offsetX = 0;

    while (offsetX < sourceImage.size.width) {
        NSUInteger row = 0;
        NSUInteger offsetY = 0;
        
        while (offsetY < sourceImage.size.height) {
            CGRect tileFrame = CGRectMake(offsetX, offsetY, self.tileSize.width, self.tileSize.height);
            
            UIImage *tileImage = [sourceImage imageInRect:tileFrame];
            NSString *tileName = [self tileNameWithZoom:zoom row:row column:column];
            
        
            dispatch_group_async(self.group, self.queue, ^{
                [self saveImage:tileImage withName:tileName];
            });
            
            row += 1;
            offsetY += self.tileSize.height;
        }
        
        column += 1;
        offsetX += self.tileSize.width;
    }
    
    dispatch_group_wait(self.group, DISPATCH_TIME_FOREVER);
}

- (void)prepareOutputFolder
{
    NSAssert(self.outputFolderPath, @"Output folder should be specified by the user");
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.outputFolderPath]) {
        [fileManager createDirectoryAtPath:self.outputFolderPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
}

- (NSString *)tileNameWithZoom:(CGFloat)scale row:(NSUInteger)row column:(NSUInteger)column
{
    NSString *fileExtension = (self.outputFileType == OutputFileTypePNG) ? @"png" : @"jpg";
    NSString *fileName = [NSString stringWithFormat:@"%@_%d_%lu_%lu.%@",
                          self.outputFileName,
                          (int)(scale * 1000),
                          (unsigned long)row,
                          (unsigned long)column,
                          fileExtension];
    return fileName;
}

- (void)saveImage:(UIImage *)image withName:(NSString *)fileName
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

@end
