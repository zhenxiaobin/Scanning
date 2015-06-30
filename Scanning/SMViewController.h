//
//  SMViewController.h
//  Scanning
//
//  Created by tsmc on 15/6/30.
//  Copyright (c) 2015年 SevenMay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMScanViewController.h"

@interface SMViewController : UIViewController <SMScanViewControllerDelegate>

- (IBAction)startScan:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *resultScan;

@end
