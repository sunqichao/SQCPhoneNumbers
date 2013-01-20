//
//  FindNumberDataSource.h
//  SQCPhoneNumbers
//
//  Created by sun qichao on 13-1-16.
//  Copyright (c) 2013年 sun qichao. All rights reserved.
//

#import <Foundation/Foundation.h>


#define HTTPBODY(number,user) [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"><soap12:Body><getMobileCodeInfo xmlns=\"http://WebXml.com.cn/\"><mobileCode>%@</mobileCode><userID>%@</userID></getMobileCodeInfo></soap12:Body></soap12:Envelope>",number,user]
#define CONTENTTYPE @"application/soap+xml; charset=utf-8"
#define WEBSERVICEURL @"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx"
#define CONNECTIONFAILED @"创建connection的时候失败"
#define REVEIVEFAILED @"接收数据时报错"
#define PARSEFAILED @"解析xml的时候报错"
#define NOTINCLUDE @"没有此号码记录"


typedef void (^findResultBlock)(NSString *number,NSString *province,NSString *city,NSString *type);
typedef void (^failedBlock)(NSString *error);
/**
    使用的时候调用单利方法，再调查询的方法，传进去手机号，例如：
 [[FindNumberDataSource shareDataSource]
 findPhoneNumbers:_numberTextField.text
 resultBlock:^(NSString *number, NSString *province, NSString *city, NSString *type) {
 
 
 } failedBlock:^(NSString *error) {
 NSLog(@"%@",error);
 
 }];
 
 */
@interface FindNumberDataSource : NSObject<NSXMLParserDelegate, NSURLConnectionDelegate>

+ (FindNumberDataSource *)shareDataSource;
/**
 @param 要查询的手机号码
 @return 返回一个block，其中有四个参数：1.手机号码。2.省份。3.城市。4.手机卡类型
 */
- (void)findPhoneNumbers:(NSString *)numbers resultBlock:(findResultBlock)block failedBlock:(failedBlock)failed;


@end

