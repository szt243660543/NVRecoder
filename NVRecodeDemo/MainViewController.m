//
//  MainViewController.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/28.
//

#import "MainViewController.h"
#import "NVVideo.h"
#import "NVRecord.h"
#import "NVCamera.h"

@interface MainViewController ()<NVRecordDelegate>
{
    int _recodeTag;
}

@property(nonatomic, strong)NVRecord *recodeUtil;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    _recodeTag = 0;
    
    NSString *itemPath = [[NSBundle mainBundle] pathForResource:@"videoinfo0" ofType:@".mp4"];
    NSURL *url = [NSURL fileURLWithPath:itemPath];
    
    NSString *itemPath1 = [[NSBundle mainBundle] pathForResource:@"AR1" ofType:@".mp4"];
    NSURL *url1 = [NSURL fileURLWithPath:itemPath1];
    
//    NSString *itemPath2 = [[NSBundle mainBundle] pathForResource:@"AR2" ofType:@".mp4"];
//    NSURL *url2 = [NSURL fileURLWithPath:itemPath2];
    
    NVVideo *video = [[NVVideo alloc] initAVPlayerVideoWithURL:url];
    [video setVideoRect:CGRectMake(0, 0, 1.0, 0.25)];
    [video changeFilter:SZTVR_NORMAL];
    [self addRenderTarget:video];

    NVVideo *video1 = [[NVVideo alloc] initAVPlayerVideoWithURL:url];
    [video1 setVideoRect:CGRectMake(0.0, 0.25, 1.0, 0.25)];
    [video1 changeFilter:SZTVR_POLKADOT];
    [self addRenderTarget:video1];
    
//    NVVideo *video4 = [[NVVideo alloc] initAVPlayerVideoWithURL:url];
//    [video4 setVideoRect:CGRectMake(0.5, 0, 0.5, 0.25)];
//    [video4 changeFilter:SZTVR_LUMINANCE];
//    [self addRenderTarget:video4];
    
    NVVideo *video2 = [[NVVideo alloc] initAVPlayerVideoWithURL:url1];
    [video2 setVideoRect:CGRectMake(0.0, 0.5, 0.5, 0.5)];
    [video2 changeFilter:SZTVR_NORMAL];
    [self addRenderTarget:video2];
    
//    NVVideo *video3 = [[NVVideo alloc] initAVPlayerVideoWithURL:url2];
//    [video3 setVideoRect:CGRectMake(0.5, 0.5, 0.5, 0.5)];
//    [video3 changeFilter:SZTVR_NORMAL];
//    [self addRenderTarget:video3];
    
    // add camera
    NVCamera *camera = [[NVCamera alloc] initWithDevicePosition:CAMERA_BACK];
    [camera setVideoRect:CGRectMake(0.5, 0.5, 0.5, 0.5)];
    [camera changeFilter:SZTVR_NORMAL];
    [self addRenderTarget:camera];
}

- (void)initUI
{
    UIButton *recode = [UIButton buttonWithType:UIButtonTypeCustom];
    recode.frame = CGRectMake(0.0, 20.0, 100.0, 50.0);
    recode.backgroundColor = [UIColor grayColor];
    [recode setTitle:@"Recode" forState:UIControlStateNormal];
    [recode setTitle:@"Recoding" forState:UIControlStateSelected];
    [recode addTarget:self action:@selector(clickRecode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recode];
}

- (void)clickRecode:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected){
        [self initRecodeUtil];
        [self.recodeUtil startRecording];
    }else{
        [self.recodeUtil endRecording];
    }
}

- (void)initRecodeUtil
{
    if (self.recodeUtil) {
        self.recodeUtil = nil;
    }
    
    _recodeTag ++;
    self.recodeUtil = [[NVRecord alloc] initWithRecodeName:[NSString stringWithFormat:@"recode_%d", _recodeTag]];
    self.recodeUtil.renderTarget = [self getSurfaceBuffer];
    self.recodeUtil.delegate = self;
}

#pragma mark NVRecordDelegate
- (void)endMerge
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"合成视频到相册" message:@"成功保存到相册中!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
