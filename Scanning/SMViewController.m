//
//  SMViewController.m
//  Scanning
//
//  Created by tsmc on 15/6/30.
//  Copyright (c) 2015年 SevenMay. All rights reserved.
//

#import "SMViewController.h"

@interface SMViewController ()

@end

@implementation SMViewController

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"signIn_nav"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)startScan:(id)sender
{
    SMScanViewController *scanVC = [[SMScanViewController alloc]init];
    scanVC.delegate = self;
    [self.navigationController pushViewController:scanVC animated:YES];
    
}

- (void)getScanResult:(NSString *)str
{
    self.resultScan.text = str;
}
@end
