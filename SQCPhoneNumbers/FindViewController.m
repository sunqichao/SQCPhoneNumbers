//
//  FindViewController.m
//  SQCPhoneNumbers
//
//  Created by sun qichao on 13-1-16.
//  Copyright (c) 2013年 sun qichao. All rights reserved.
//

#import "FindViewController.h"
#import "FindNumberDataSource.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushMethod:(id)sender {
    NSString *content = _numberTextField.text;
    if ([content length]<7) {
        NSLog(@"at least 7");
    }else{
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
   
    
}
@end
