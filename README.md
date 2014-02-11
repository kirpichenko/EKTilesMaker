##EKTilesMaker
Simple iOS utility that slices provided original image onto tiles. Tiles may be used for displaying large images on different detalization levels.

You can find example of tiles usage in `EKTilesMakerDemo` project that is very similar to Apple's [PhotoScroller](https://developer.apple.com/library/ios/samplecode/photoscroller/Introduction/Intro.html) sample.  


##Usage
1. Create instance of `EKTilesMaker` class. 
2. Provide source image file and output folder paths.
3. Set tile name.
4. Add zoom levels for which tiles should be created.
5. Set tiles size and format.
6. Provide completion block.
7. Call `createTiles` method.
8. Get your tiles from output folder.
<pre><code>  
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
</code></pre>  
  
##Example  
Original image from demo project can be sliced onto 6 parts for 0.125 zoom level and 256x256 tiles size.

####Original image
![Alt text](https://github.com/kirpichenko/EKTilesMaker/blob/master/EKtilesMakerDemo/EKtilesMakerDemo/Resources/photo_small.jpg?raw=true)

####Tiles
![Alt text](https://github.com/kirpichenko/EKTilesMaker/blob/master/README/tile_125_0_0.png?raw=true).
![Alt text](https://github.com/kirpichenko/EKTilesMaker/blob/master/README/tile_125_0_1.png?raw=true).
![Alt text](https://github.com/kirpichenko/EKTilesMaker/blob/master/README/tile_125_0_2.png?raw=true)  
![Alt text](https://github.com/kirpichenko/EKTilesMaker/blob/master/README/tile_125_1_0.png?raw=true).
![Alt text](https://github.com/kirpichenko/EKTilesMaker/blob/master/README/tile_125_1_1.png?raw=true).
![Alt text](https://github.com/kirpichenko/EKTilesMaker/blob/master/README/tile_125_1_2.png?raw=true)

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/kirpichenko/ektilesmaker/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

