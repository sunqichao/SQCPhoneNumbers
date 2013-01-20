//
//  MP_AlertView.m
//  MP_NanJing
//
//  Created by MPLife.com on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MP_AlertView.h"
#import<QuartzCore/QuartzCore.h>

@implementation MP_AlertView
@synthesize showTime;

- (id)initWithTitle:(NSString *)title 
            message:(NSString *)message 
           delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle 
               type:(MP_AlertViewMode)mode
  otherButtonTitles:(NSString *)otherButtonTitles,...
{
	if(mode == MP_AlertViewModeDelault)
	{
		va_list args; 
		va_start(args, otherButtonTitles); 
		NSString *formatStr = [[NSString alloc]  initWithFormat:otherButtonTitles arguments:args];
		va_end(args);
		
		self = [super initWithTitle:title
							message:message 
						   delegate:delegate 
				  cancelButtonTitle:cancelButtonTitle 
				  otherButtonTitles:nil];
	}
	if(mode == MP_AlertViewModeAutoDismiss)
	{
		self = [super initWithTitle:@"" 
							message:message 
						   delegate:nil
				  cancelButtonTitle:nil
				  otherButtonTitles:nil];
		self.delegate = self;
		AlertViewMode = mode;
		showTime = 2.0;
	}
	return self;
}


-(void)dismissAlertView:(NSTimer*)ti
{
	[dismissTimer invalidate];
	dismissTimer = nil;
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)show
{
	if(AlertViewMode == MP_AlertViewModeAutoDismiss)
	{
        
		dismissTimer = [NSTimer scheduledTimerWithTimeInterval:showTime 
														target:self 
													  selector:@selector(dismissAlertView:) 
													  userInfo:nil 
													   repeats:NO];
	}
	[super show];
}

@end
