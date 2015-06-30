//
//  SMScanViewController.h
//  Scanning
//
//  Created by tsmc on 15/6/30.
//  Copyright (c) 2015年 SevenMay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol SMScanViewControllerDelegate <NSObject>

- (void) getScanResult:(NSString *)str;

@end

@interface SMScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice * device;
@property (nonatomic, strong) AVCaptureDeviceInput * input;
@property (nonatomic, strong) AVCaptureMetadataOutput * output;
@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

@property (nonatomic, weak) id <SMScanViewControllerDelegate> delegate;

@end