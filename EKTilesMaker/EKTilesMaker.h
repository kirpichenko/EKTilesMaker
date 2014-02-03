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

@property (nonatomic) UIImage *sourceImage;

@property (nonatomic) NSArray *scaleSizes;
@property (nonatomic) CGSize tileSize;

@property (nonatomic) NSString *outputFolderPath;
@property (nonatomic) NSString *outputFileName;
@property (nonatomic) OutputFileType outputFileType;

@end
