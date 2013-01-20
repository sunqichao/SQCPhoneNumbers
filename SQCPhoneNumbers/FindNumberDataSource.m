//
//  FindNumberDataSource.m
//  SQCPhoneNumbers
//
//  Created by sun qichao on 13-1-16.
//  Copyright (c) 2013年 sun qichao. All rights reserved.
//

#import "FindNumberDataSource.h"

@implementation FindNumberDataSource
static FindNumberDataSource *findData;
+ (FindNumberDataSource *)shareDataSource
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        findData = [[FindNumberDataSource alloc] init];
    });
    return findData;
}
//发起请求成功后用来接收传过来的data
NSMutableData *receiveData;
//用来解析响应回来的xml
NSXMLParser *xmlParser;
//发起请求的connection
NSURLConnection *connection;
//请求成功，并且数据处理成功后回调的block
findResultBlock succeedB;
//失败时回调的block
failedBlock failedB;
//需要解析的element元素标签
NSString *element = @"getMobileCodeInfoResult";
//接收的结果
NSMutableString *soapResults;
//是否找到了标签
BOOL elementFound;

- (void)findPhoneNumbers:(NSString *)numbers resultBlock:(findResultBlock)block failedBlock:(failedBlock)failed;
{
    receiveData = nil;
    xmlParser = nil;
    connection = nil;
    soapResults = nil;
    [self inquiryNumber:numbers];
    failedB = failed;
    succeedB = block;

}

- (void)inquiryNumber:(NSString *)number
{
    //首先设置请求的xml内容的body
    NSString *httpBody = HTTPBODY(number, @"");
    //创建webservice的地址
    NSURL *url = [NSURL URLWithString:WEBSERVICEURL];
    //创建request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //获得httpbody的长度
    NSString *httpBodyLength = [NSString stringWithFormat:@"%d",[httpBody length]];
    //设置request的内容
    [request addValue:CONTENTTYPE forHTTPHeaderField:@"Content-Type"];
    [request addValue:httpBodyLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    //创建connection
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        receiveData = [[NSMutableData alloc] init];
    }else{
        failedB(CONNECTIONFAILED);
    }

}


#pragma mark -
#pragma mark URL Connection Data Delegate Methods

// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
    [receiveData setLength: 0];
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    [receiveData appendData:data];
}

// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
    connection = nil;
    receiveData = nil;
    failedB(REVEIVEFAILED);
}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    NSString *theXML = [[NSString alloc] initWithBytes:[receiveData mutableBytes]
                                                length:[receiveData length]
                                              encoding:NSUTF8StringEncoding];
    
    // 打印出得到的XML
    NSLog(@"%@", theXML);
    // 使用NSXMLParser解析出我们想要的结果
    xmlParser = [[NSXMLParser alloc] initWithData: receiveData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
    
}

#pragma mark -
#pragma mark XML Parser Delegate Methods

// 开始解析一个元素名
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict {
    if ([elementName isEqualToString:element]) {
        if (!soapResults) {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
    
}

// 追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string {
    if (elementFound) {
        [soapResults appendString: string];
    }
    
}

// 结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:element]) {
        if ([soapResults isEqualToString:NOTINCLUDE]) {
            failedB(NOTINCLUDE);
        }else{
            NSString *number = @"";
            NSString *province = @"";
            NSString *city = @"";
            NSString *type = @"";
            NSArray *arr = [soapResults componentsSeparatedByString:@"："];
            number = [arr objectAtIndex:0];
            NSString *two = [arr objectAtIndex:1];
            NSArray *arr_two = [two componentsSeparatedByString:@" "];
            province = [arr_two objectAtIndex:0];
            city = [arr_two objectAtIndex:1];
            type = [arr_two objectAtIndex:2];
            succeedB(number,province,city,type);
            elementFound = FALSE;
            // 强制放弃解析
            [xmlParser abortParsing];
        }
        
    }
}

// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (soapResults) {
        soapResults = nil;
    }
}

// 出错时，例如强制结束解析
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (soapResults) {
        soapResults = nil;
    }
    failedB(PARSEFAILED);
}










@end
