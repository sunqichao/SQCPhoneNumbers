//
//  MP_AlertView.h
//  MP_NanJing
//
//  Created by MPLife.com on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
	MP_AlertViewModeDelault,
	MP_AlertViewModeAutoDismiss
}MP_AlertViewMode;

@interface MP_AlertView :UIAlertView
{
	NSTimer *dismissTimer;
	MP_AlertViewMode AlertViewMode;
	NSTimeInterval showTime;
}
@property (assign) NSTimeInterval showTime;

//使用的时候如果是自动消失的就不用传cancelbutton的名字了，还有otherButton的名字也不用传了
//如果是默认的状态则需要传cancelButton和OtherButton
- (id)initWithTitle:(NSString *)title 
            message:(NSString *)message 
           delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle 
               type:(MP_AlertViewMode)mode
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
@end

