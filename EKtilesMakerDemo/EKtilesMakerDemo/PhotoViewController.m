//
//  TilesViewController.m
//  EKTilesMakerDemo
//
//  Created by Evgeniy Kirpichenko on 2/11/14.
//  Copyright (c) 2014 Evgeniy Kirpichenko. All rights reserved.
//

#import "PhotoViewController.h"

#import "EKTilesMaker.h"
#import "TilingView.h"

static NSString *const kTileName = @"tile";

@interface PhotoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *activityView;

@property (weak, nonatomic) UIView *tilingView;
@end

@implementation PhotoViewController

#pragma mark - view life cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.activityView setHidden:NO];
    [self tilePhotoWithcompletion:^{
        [self displayTilingViewWithSize:[self imageSize]];
        [self.activityView setHidden:YES];
    }];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.tilingView;
}

#pragma mark - private

- (void)tilePhotoWithcompletion:(void(^)(void))completion
{
    EKTilesMaker *tilesMaker = [EKTilesMaker new];

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"photo" ofType:@"jpg"];
    [tilesMaker setSourceImagePath:imagePath];
    [tilesMaker setOutputFolderPath:self.tilesFolderPath];
    [tilesMaker setOutputFileName:kTileName];
    [tilesMaker setZoomLevels:@[@1, @0.5, @0.25, @0.125]];
    [tilesMaker setTileSize:CGSizeMake(256, 256)];
    [tilesMaker setOutputFileType:OutputFileTypePNG];
    [tilesMaker setCompletionBlock:completion];
    
    [tilesMaker createTiles];
}

- (void)displayTilingViewWithSize:(CGSize)size
{
    TilingView *tilingView = [[TilingView alloc] initWithImageName:kTileName
                                                              size:size
                                                   tilesFolderPath:[self tilesFolderPath]];
    [self setTilingView:tilingView];
    [self.scrollView addSubview:tilingView];
    [self.scrollView setContentSize:size];
    [self.scrollView setZoomScale:0.125];
    
    CGSize scrollViewSize = [self.scrollView bounds].size;
    CGFloat minimumZoom = MIN(scrollViewSize.width / size.width, scrollViewSize.height / size.height);
    [self.scrollView setMinimumZoomScale:minimumZoom];
}

- (NSString *)tilesFolderPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tilesFolderPath = [paths[0] stringByAppendingPathComponent:@"tiles"];
    
    return tilesFolderPath;
}

- (CGSize)imageSize
{
    NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:@"photo" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    
    return [image size];
}

@end
