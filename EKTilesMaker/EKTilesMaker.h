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

@interface EKTilesMaker : NSObject

- (void)createTiles;

@property (nonatomic) NSString *sourceImagePath;
@property (nonatomic) NSString *outputFolderPath;
@property (nonatomic) NSString *outputFileName;

@property (nonatomic) NSArray *zoomLevels;
@property (nonatomic) CGSize tileSize;
@property (nonatomic) OutputFileType outputFileType;

@property (nonatomic, copy) void(^completionBlock)();

@end
