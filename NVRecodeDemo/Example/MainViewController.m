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
#import "CollectionViewCell.h"

static NSString *cellID = @"cell";

@interface MainViewController ()<NVRecordDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    int _recodeTag;
    
    int _index;
    
    NVCamera *camera;
}

@property(nonatomic, strong)NVRecord *recodeUtil;

@property(nonatomic, strong) UICollectionView *myCollectionView;

@property(nonatomic, copy)NSArray *items;

@end

@implementation MainViewController

- (instancetype)initWithIndex:(int)index
{
    self = [super init];
    
    if (self) {
        _index = index;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    _recodeTag = 0;
    
    
    camera = [[NVCamera alloc] initWithDevicePosition:CAMERA_FRONT];
    camera.contentMode = NVModeScaleToFill;
    camera.frame = self.view.frame;
    
    [self addRenderTarget:camera];
    
    if (_index == 1) {
        [self cameraFilterDemo];
    }
    
    if (_index == 2) {
        [camera changeFilter:FAKE3D];
    }
    
    if (_index == 3) {
        [camera changeFilter:SOUL_SCALE];
    }
    
    if (_index == 4) {
        [camera changeFilter:HALLUCINATION];   
    }
    
    if (_index == 5) {
        [camera changeFilter:MULTICOLOURED];
    }
    
    if (_index == 6) {
        [camera changeFilter:OLD_VIDEO];
    }
    
    if (_index == 7) {
        [camera changeFilter:X_INVERT];
    }
    
    if (_index == 8) {
        [camera changeFilter:EDGE_SHINE];
    }
    
    if (_index == 9) {
        [camera changeFilter:COLUMNS_SLICED];
    }
    
//    NSString *itemPath = [[NSBundle mainBundle] pathForResource:@"videoinfo0" ofType:@".mp4"];
//    NSURL *url = [NSURL fileURLWithPath:itemPath];
//
//    NSString *itemPath1 = [[NSBundle mainBundle] pathForResource:@"AR1" ofType:@".mp4"];
//    NSURL *url1 = [NSURL fileURLWithPath:itemPath1];
    
    /*
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
    */
    
    // add camera
//    camera = [[NVCamera alloc] initWithDevicePosition:CAMERA_FRONT];
////    camera.contentMode = NVModeScaleAspectFill;
//    camera.contentMode = NVModeScaleToFill;
////    camera.scale = NVPosition(0.5, 0.5, 0.5);
////    camera.frame = CGRectMake(0.0, 210.0, 375.0, 265.0);
//    camera.frame = CGRectMake(0, 0, 375, 667);
//    [camera changeFilter:SOUL_SCALE];
//
////    NSURL *curver = [[NSBundle mainBundle] URLForResource:@"滤镜_棉花糖" withExtension:@".acv"];
////    [camera loadACVFileUrl:curver];
//
////    NVCIFilter *
////    filter = [[NVCIFilter alloc] initWithFilterMode:CIVibrance];
////    [filter setValue:[NSNumber numberWithFloat:0.0] forKey:@"inputAmount"];
////    [camera addCIFilter:filter];
//
//    [self addRenderTarget:camera];
    
    /*
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(30, 400, 315, 50)];
    slider.minimumValue = 1.0;
    slider.maximumValue = 1.2;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    */
    
//    UISlider *slider1 = [[UISlider alloc] initWithFrame:CGRectMake(30, 500, 315, 50)];
//    slider1.minimumValue = 0.0;
//    slider1.maximumValue = 1.0;
//    [slider1 addTarget:self action:@selector(sliderValueChangedT:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:slider1];
//
//    UISlider *slider2 = [[UISlider alloc] initWithFrame:CGRectMake(30, 600, 315, 50)];
//    slider2.minimumValue = 1.0;
//    slider2.maximumValue = 2.5;
//
//    [slider2 addTarget:self action:@selector(sliderValueChangedB:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:slider2];
}

/*
-(void)sliderValueChanged:(UISlider *)slider
{
//    camera.dy_scale = slider.value;
//    _toneLevel = 0.47;
//    _beautyLevel = 0.42;
//    _brightLevel = 0.34;
    NSLog(@"slider value%f",slider.value);
    camera.brightLevel = slider.value;
//    camera.brightLevel = slider.value;
//    camera.toneLevel = slider.value;
}
*/

-(void)sliderValueChangedT:(UISlider *)slider
{
    NSLog(@"slider value%f",slider.value);
//    camera.toneLevel = slider.value;
    camera.mixturePercent = slider.value;
}

-(void)sliderValueChangedB:(UISlider *)slider
{
    NSLog(@"slider value%f",slider.value);
    camera.scalePercent = slider.value;
//    [filter setValue:[NSNumber numberWithFloat:slider.value] forKey:@"inputAmount"];
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

#pragma mark 摄像头滤镜效果
- (void)cameraFilterDemo
{
    [camera changeFilter:TONE_CURVE];
    
    NSURL *curver = [[NSBundle mainBundle] URLForResource:@"正常" withExtension:@".acv"];
    [camera loadACVFileUrl:curver];
    
    self.items = @[@"柏林",@"薄荷",@"碧海",@"冰凉",@"布丁",@"草木绿",@"初夏",@"纯净",@"冬青",@"黄昏",@"回忆",@"加州",@"可爱",@"棉花糖",
                   @"奶茶",@"暖暖",@"暖阳",@"片场",@"清新",@"曲奇",@"森林",@"天真",@"童话",@"晚秋",@"午后",@"夜店",@"印象",@"正常",@"周末"];
    
    /********************** UI **********************/
    CGRect collectionViewFrame = CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(-20, 10, 0, 10);
    
    flowLayout.itemSize = CGSizeMake(70, 70);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    _myCollectionView = collectionView;
    [self.view addSubview:collectionView];
    
    [self.myCollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.cover.image = [UIImage imageNamed:self.items[indexPath.row]];
    cell.title.text = self.items[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *curver = [[NSBundle mainBundle] URLForResource:self.items[indexPath.row] withExtension:@".acv"];
    [camera loadACVFileUrl:curver];
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

@end
