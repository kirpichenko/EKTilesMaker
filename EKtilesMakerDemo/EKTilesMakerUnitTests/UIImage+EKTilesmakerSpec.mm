#import "UIImage+EKTilesMaker.h"
#import "CedarAsync.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIImageTransformingSpec)

describe(@"UIImage", ^{
    __block UIImage *sourceImage;

    beforeEach(^{
        NSString *sourceImagePath = [[NSBundle mainBundle] pathForResource:@"photo_small" ofType:@"jpg"];
        sourceImage = [UIImage imageWithContentsOfFile:sourceImagePath];
    });
    
    context(@"Scaled 1072x804 source image", ^{
        it(@"should have 536x402 size", ^{
            UIImage *scaledImage = [sourceImage imageWithScale:0.5];
            CGSize scaledImageSize = [scaledImage size];
            
            scaledImageSize.width should be_close_to(536);
            scaledImageSize.height should be_close_to(402);
        });
        
        it(@"should be able to be created in dispatch queue", ^{
            __block UIImage *scaledImage;
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                scaledImage = [sourceImage imageWithScale:0.5];
            });
            
            in_time(scaledImage) should_not be_nil();
        });
    });
    
    context(@"Cropped source image", ^{
        __block UIImage *croppedImage;
        
        beforeEach(^{
            croppedImage = [sourceImage imageInRect:CGRectMake(256, 128, 256, 64)];
        });
        
        it(@"should have 256x256 size", ^{
            CGSize croppedImageSize = [croppedImage size];
            
            croppedImageSize.width should be_close_to(256);
            croppedImageSize.height should be_close_to(64);
        });
    });
});

SPEC_END
