#import "EKTilesMaker.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(EKTilesMakerSpec)

describe(@"EKTilesMaker", ^{
    __block EKTilesMaker *tilesMaker;
    __block UIImage *sourceImage;
    __block NSString *outputFolderPath;
    __block NSString *outputFileName;

    beforeEach(^{
        tilesMaker = [EKTilesMaker new];
        
        NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:@"photo" ofType:@"jpg"];
        sourceImage = [UIImage imageWithContentsOfFile:imageFilePath];
        tilesMaker.sourceImage = sourceImage;

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsFolder = [paths lastObject];
        outputFolderPath = [documentsFolder stringByAppendingPathComponent:@"tiles"];
        tilesMaker.outputFolderPath = outputFolderPath;
        
        outputFileName = @"tile";
        tilesMaker.outputFileName = outputFileName;
        
        tilesMaker.outputFileType = OutputFileTypeJPG;
    });
    
    afterEach(^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:outputFolderPath error:nil];
    });
    
    it(@"Should create 17 * 13 = 221 tiles in output folder with default tile size 256x256px for x1 scale", ^{
        [tilesMaker createTiles];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *files = [fileManager contentsOfDirectoryAtPath:outputFolderPath error:nil];
        
        [files count] should equal(221);
    });
});

SPEC_END
