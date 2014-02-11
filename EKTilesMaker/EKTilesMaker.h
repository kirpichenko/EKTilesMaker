//
//  EKTileMaker.h
//  EKTilesMakerDemo
//
//  Created by Evgeniy Kirpichenko on 2/3/14.
//  Copyright (c) 2014 Evgeniy Kirpichenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OutputFileType)
{
    OutputFileTypePNG,
    OutputFileTypeJPG
};

/**
 Class that create tiles based on the provided source image
 */
@interface EKTilesMaker : NSObject

- (void)createTiles;

///Path to the source image
@property (nonatomic) NSString *sourceImagePath;

///Output folder path for tiles storing
@property (nonatomic) NSString *outputFolderPath;

/// Name of output tiles
@property (nonatomic) NSString *outputFileName;

/** 
 Array of zoom levels for tiles creating. If @[@1, @0.5] scales are provided then tiles will be
 created for original image with x1 and x0.5 scales
*/
@property (nonatomic) NSArray *zoomLevels;

/// The size of output tiles images
@property (nonatomic) CGSize tileSize;

/**
 Image type of tiles. Provide OutputfileTypePNG for storing tiles in png format or
 OutputfileTypePNG for storing tiles as jpg. Default value is OutputfileTypePNG
 */
@property (nonatomic) OutputFileType outputFileType;

///Completion block to be called after tiling process did finish
@property (nonatomic, copy) void(^completionBlock)();

@end
