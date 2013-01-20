//
//  FindViewController.m
//  SQCPhoneNumbers
//
//  Created by sun qichao on 13-1-16.
//  Copyright (c) 2013年 sun qichao. All rights reserved.
//

#import "FindViewController.h"
#import "FindNumberDataSource.h"
#import "MP_AlertView.h"
@interface FindViewController ()

@end

@implementation FindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
bool isConnected;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textfieldChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        isConnected = YES;
        
    };
    reach.unreachableBlock = ^(Reachability *reachability)
    {
        isConnected = NO;
        
    };
    [reach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability *reach = [note object];
    if ([reach isReachable])
    {
        isConnected = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:REACHABLE];

        });

    }else
    {
        isConnected = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:UNREACHABLE];
            
        });
    }

}

- (void)textfieldChange:(id)sender
{
    NSString *content = _numberTextField.text;
    if ([content length]>=7) {
        [self findNumberMethod];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [_numberTextField becomeFirstResponder];
    _numberTextField.keyboardType = UIKeyboardTypePhonePad;
    _numberTextField.clearButtonMode = UITextFieldViewModeAlways;
    _numberTextField.clearsOnBeginEditing = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushMethod:(id)sender {
    NSString *content = _numberTextField.text;
    if (!isConnected) {
        [self showAlert:UNREACHABLE];
    }else{
        if ([content length]<7) {
            NSLog(@"at least 7");
        }else{
            [self findNumberMethod];
        }
    }
       
}

- (void)findNumberMethod
{
    NSString *content = _numberTextField.text;
    [[FindNumberDataSource shareDataSource]
     findPhoneNumbers:content
     resultBlock:^(NSString *number, NSString *province, NSString *city, NSString *type) {
         _numbers.text = number;
         _shengfen.text = province;
         _chengshi.text = city;
         _kaleixing.text = type;
         
     } failedBlock:^(NSString *error) {
         NSLog(@"%@",error);
         
     }];

}
- (void)showAlert:(NSString *)message
{
    MP_AlertView *alert = [[MP_AlertView alloc] initWithTitle:@"提示"
                                                      message:message
                                                     delegate:self
                                            cancelButtonTitle:nil
                                                         type:MP_AlertViewModeAutoDismiss
                                            otherButtonTitles:nil, nil];
    [alert show];
}
@end
