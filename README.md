# NVRecodeDemo
It is a lite library to render multiple videos and recoder a new video.

## Preview
![ScreenShot](https://raw.githubusercontent.com/ashqal/MD360Player4iOS/master/screenshot.png)
![ScreenShot](https://raw.githubusercontent.com/ashqal/MD360Player4iOS/master/screenshot2.png)
</br>
[Raw 360 Panorama Video](http://d8d913s460fub.cloudfront.net/krpanocloud/video/airpano/video-1920x960a.mp4)

## USAGE
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a AVPlayerItem
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.mURL];
    [self.player setPlayerItem:playerItem];
    [self.player play];
    
    /////////////////////////////////////////////////////// MDVRLibrary
    MDVRConfiguration* config = [MDVRLibrary createConfig];
    
    [config asVideo:playerItem];
    [config setContainer:self view:self.view];
    
    // optional
    [config displayMode:MDModeDisplayNormal];
    [config interactiveMode:MDModeInteractiveMotion];
    [config pinchEnabled:true];
    [config setDirectorFactory:self];
    
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
}
```

## Supported Configuration
```objc
typedef NS_ENUM(NSInteger, MDModeInteractive) {
    MDModeInteractiveTouch,
    MDModeInteractiveMotion,
    MDModeInteractiveMotionWithTouch,
};

typedef NS_ENUM(NSInteger, MDModeDisplay) {
    MDModeDisplayNormal,
    MDModeDisplayGlass,
};
```

## Enabled Pinch Gesture
```objc
/////////////////////////////////////////////////////// MDVRLibrary
MDVRConfiguration* config = [MDVRLibrary createConfig];

...
[config pinchEnabled:true];

self.vrLibrary = [config build];
/////////////////////////////////////////////////////// MDVRLibrary
```

## Custom Director Factory
```objc

@interface CustomDirectorFactory : NSObject<MD360DirectorFactory>
@end

@implementation CustomDirectorFactory

- (MD360Director*) createDirector:(int) index{
    MD360Director* director = [[MD360Director alloc]init];
    switch (index) {
        case 1:
            [director setEyeX:-2.0f];
            [director setLookX:-2.0f];
            break;
        default:
            break;
    }
    return director;
}

@end

@implementation VideoPlayerViewController
...
- (void) initPlayer{
   	...
    /////////////////////////////////////////////////////// MDVRLibrary
    MDVRConfiguration* config = [MDVRLibrary createConfig];
   	...
    [config [[CustomDirectorFactory alloc]init]]; // pass in the custom factory
    ...
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
}

@end

```

## 360 Bitmap Support
```objc
@interface BitmapPlayerViewController ()<IMDImageProvider>

@end

@implementation BitmapPlayerViewController

...

- (void) initPlayer{
    ...
    /////////////////////////////////////////////////////// MDVRLibrary
    MDVRConfiguration* config = [MDVRLibrary createConfig];
    ...
    [config asImage:self];
    ...
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
   
}

// implement the IMDImageProvider protocol here.
-(void) onProvideImage:(id<TextureCallback>)callback{
    //
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:self.mURL options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                NSLog(@"progress:%ld/%ld",receivedSize,expectedSize);
                                // progression tracking code
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if ( image && finished) {
                                   // do something with image
                                   if ([callback respondsToSelector:@selector(texture:)]) {
                                       [callback texture:image];
                                   }
                               }
                           }];
    
    
}

@end
```
See [BitmapPlayerViewController.m](https://github.com/ashqal/MD360Player4iOS/blob/master/MD360Player4iOS/BitmapPlayerViewController.m)

## Reference
* [360VR](https://github.com/szt243660543/360VR)
* [Thanks to vimeo/VIMVideoPlayer](https://github.com/vimeo/VIMVideoPlayer)
