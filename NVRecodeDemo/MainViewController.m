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
    
    NVVideo *video = [[NVVideo alloc] initAVPlayerVideoWithURL:url1];
    video.frame = CGRectMake(0.0, 0.0, 100, 200);
    video.contentMode = NVModeScaleAspectFill;
    [video changeFilter:SZTVR_NORMAL];
    [self addRenderTarget:video];

    NVVideo *video1 = [[NVVideo alloc] initAVPlayerVideoWithURL:url];
    video1.frame = CGRectMake(100.0, 0.0, 275.0, 200.0);
    video1.contentMode = NVModeScaleAspectFill;
    [video1 changeFilter:SZTVR_NORMAL];
    [self addRenderTarget:video1];
    
    NVVideo *video2 = [[NVVideo alloc] initAVPlayerVideoWithURL:url];
    video2.frame = CGRectMake(0.0, 667.0 - 190.0, 375.0, 190.0);
    video2.contentMode = NVModeScaleAspectFill;
    [video2 changeFilter:SZTVR_LUMINANCE];
    [self addRenderTarget:video2];
    
    // add camera
    NVCamera *camera = [[NVCamera alloc] initWithDevicePosition:CAMERA_BACK];
    camera.contentMode = NVModeScaleAspectFill;
    camera.frame = CGRectMake(0.0, 210.0, 375.0, 265.0);
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
