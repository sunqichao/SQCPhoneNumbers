//
//  FindViewController.h
//  SQCPhoneNumbers
//
//  Created by sun qichao on 13-1-16.
//  Copyright (c) 2013年 sun qichao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#define REACHABLE @"网络已连接"
#define UNREACHABLE @"网络断开"



@interface FindViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *shengfen;
@property (weak, nonatomic) IBOutlet UILabel *chengshi;
@property (weak, nonatomic) IBOutlet UILabel *kaleixing;
@property (weak, nonatomic) IBOutlet UILabel *numbers;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
- (IBAction)pushMethod:(id)sender;

@end
