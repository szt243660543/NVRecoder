# NVRecodeDemo
It is a lite library to render multiple videos and recoder a new video.

## Preview

![ScreenShot](https://github.com/szt243660543/NVRecodeDemo/blob/master/IMG_0520.png)
</br>

![ScreenShot](https://github.com/szt243660543/NVRecodeDemo/blob/master/IMG_0519.png)
</br>

## USAGE

   ### first step
   Make sure in you own controller which you need to use the function is integrated NVViewController.h
   
   ### second step
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create video url
    NSString *itemPath = [[NSBundle mainBundle] pathForResource:@"videoinfo0" ofType:@".mp4"];
    NSURL *url = [NSURL fileURLWithPath:itemPath];
 
    // create video object
    NVVideo *video = [[NVVideo alloc] initAVPlayerVideoWithURL:url];
    // set video size to screen
    [video setVideoRect:CGRectMake(0, 0, 1.0, 1.0)];
    // set filter
    [video changeFilter:SZTVR_PIXELATE];
    // add to render scene
    [self addRenderTarget:video];
}
```
  ### recoder video
  ```objc
  
   - (void)initRecodeUtil
   {
       // create recode handle
       self.recodeUtil = [[NVRecord alloc] initWithRecodeName:[NSString stringWithFormat:@"recode_demo"]];
       self.recodeUtil.renderTarget = [self getSurfaceBuffer];
       self.recodeUtil.delegate = self;
   }
   
       // method
       [self.recodeUtil startRecording];
       
       [self.recodeUtil endRecording];
   
  ```

## Supported Configuration
```objc
typedef NS_ENUM(NSInteger, SZTFilterMode) {
    SZTVR_NORMAL,           // 普通
    SZTVR_LUMINANCE,        // 像素色值亮度平均，图像黑白 (黑白效果)
    SZTVR_PIXELATE,         // 马赛克
    SZTVR_EXPOSURE,         // 曝光 (美白)
    SZTVR_DISCRETIZE,       // 离散
    SZTVR_BLUR,             // 模糊
    SZTVR_BILATERAL,        // 双边模糊
    SZTVR_HUE,              // 饱和度
    SZTVR_POLKADOT,         // 像素圆点花样
    SZTVR_GAMMA,            // 伽马线
    SZTVR_GLASSSPHERE,      // 水晶球效果
    SZTVR_CROSSHATCH,       // 法线交叉线
};

```
See [MainViewController.m](https://github.com/szt243660543/NVRecodeDemo/blob/master/NVRecodeDemo/MainViewController.m)

## Reference
* [360VR](https://github.com/szt243660543/360VR)
* [Thanks to vimeo/VIMVideoPlayer](https://github.com/vimeo/VIMVideoPlayer)

## Found an Issue?
Please file it in the git issue tracker.
