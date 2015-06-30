//
//  SMScanViewController.m
//  Scanning
//
//  Created by tsmc on 15/6/30.
//  Copyright (c) 2015年 SevenMay. All rights reserved.
//

#import "SMScanViewController.h"
#import "SMBackButton.h"

#define kScreenScale [UIScreen mainScreen].bounds.size.width/320.0

@interface SMScanViewController ()
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@end

@implementation SMScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configNav];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, self.view.frame.size.width - 40, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    UILabel *labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(20, 340, self.view.frame.size.width - 40, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.numberOfLines = 2;
    labIntroudction.textColor = [UIColor greenColor];
    labIntroudction.font = [UIFont systemFontOfSize:13];
    labIntroudction.text = @"请将条形码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    upOrdown = NO;
    num = 0;
    
    UIImage* img = [[UIImage imageNamed:@"line.png"] stretchableImageWithLeftCapWidth:110 topCapHeight:1.5];
    
    
    _line = [[UIImageView alloc] initWithImage:img];
    _line.frame = CGRectMake(50*kScreenScale, 35, 220*kScreenScale, 2);
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

- (void)configNav
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"signIn_nav"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 100, 40);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"扫描条形码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    SMBackButton *button = [[SMBackButton alloc] initWithFrame:CGRectMake(0, 0, 42.5, 15)];
    [button addTarget:self action:@selector(backAction)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50*kScreenScale, 35*kScreenScale+2*num, 220*kScreenScale, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50*kScreenScale, 35*kScreenScale+2*num, 220*kScreenScale, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

-(void)backAction
{
    [timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupCamera];
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    NSError *error = nil;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error) {
        NSString* errMsg;
        if (error.code == -11852) {
            errMsg = @"请在设置中打开相机权限";
        }else{
            errMsg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
        }
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:errMsg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        return;
    }
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeUPCECode,
                                       AVMetadataObjectTypeCode39Code,
                                       AVMetadataObjectTypeCode39Mod43Code,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode93Code,
                                       AVMetadataObjectTypeCode128Code,
                                       AVMetadataObjectTypePDF417Code,
                                       AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeAztecCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(25*kScreenScale,35*kScreenScale,self.view.frame.size.width - 50*kScreenScale,290);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
    
    
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if (metadataObjects != nil && [metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    NSLog(@"%@",stringValue);
    [self.delegate getScanResult:stringValue];
    [timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        
        if (self.isViewLoaded && !self.view.window) {
            
            self.view = nil;
        }
    }
}
@end
