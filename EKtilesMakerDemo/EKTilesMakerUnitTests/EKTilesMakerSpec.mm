#import "EKTilesMaker.h"
#import "CedarAsync.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(EKTilesMakerSpec)

describe(@"EKTilesMaker", ^{
    __block EKTilesMaker *tilesMaker;
    __block NSString *outputFolderPath;
    __block NSString *outputFileName;
    
    __block BOOL finished;

    beforeEach(^{
        tilesMaker = [EKTilesMaker new];
        
        NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:@"photo_small" ofType:@"jpg"];
        tilesMaker.sourceImagePath = imageFilePath;

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsFolder = [paths lastObject];
        outputFolderPath = [documentsFolder stringByAppendingPathComponent:@"tiles"];
        tilesMaker.outputFolderPath = outputFolderPath;
        
        outputFileName = @"tile";
        tilesMaker.outputFileName = outputFileName;
        
        tilesMaker.zoomLevels = @[@1, @0.5];
        tilesMaker.outputFileType = OutputFileTypeJPG;
        tilesMaker.tileSize = CGSizeMake(128, 128);
        tilesMaker.completionBlock = ^{
            finished = YES;
        };
        
        finished = NO;
        [tilesMaker createTiles];
    });
    
    afterEach(^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:outputFolderPath error:nil];
    });
    
    context(@"Creating tiles", ^{
        __block NSArray *tiles;

        beforeEach(^{
            with_timeout(20, ^{
                in_time(finished) should be_truthy();
            });
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            tiles = [fileManager contentsOfDirectoryAtPath:outputFolderPath error:nil];
        });
        
        it(@"Should create 63 tiles (128x128) for x1 zoom level", ^{
            NSString *regex = @"tile_1000_\\d{0,9}_\\d{0,7}.jpg";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            NSArray *zoomTiles = [tiles filteredArrayUsingPredicate:predicate];
            
            [zoomTiles count] should equal(63);
        });
        
        it(@"Should create 20 tiles (128x128) for x0.5 zoom level", ^{
            NSString *regex = @"tile_500_\\d{0,5}_\\d{0,4}.jpg";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            NSArray *zoomTiles = [tiles filteredArrayUsingPredicate:predicate];
            
            [zoomTiles count] should equal(20);
        });
    });
});

SPEC_END
