//
//  YCRequest.h
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock) (id result);
typedef void (^FailBlock) (NSDictionary *result);

@interface YCRequest : NSObject

@property (copy) SuccessBlock successBlock;
@property (copy) FailBlock failBlock;

- (id)initWithBaseURL:(NSURL *)url method:(NSString *)method serviceURL:(NSString *)serviceURL;
- (void)setRequestSerializer:(id)type;
- (void)setResponseSerializer:(id)type;
- (void)addHeaderWithKey:(NSString *)key value:(NSString *)value;
- (void)addParamWithKey:(NSString *)key value:(id)value;
- (void)addFileWithFileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;
- (void)request;
- (void)cancel;

- (NSTimeInterval)elapsedTime;
- (NSString *)contentMIMETypeForImageData:(NSData *)data;
- (void)processResponseHeader:(NSDictionary *)headers;
- (id)parseContentWithResponseObject:(id)responseObject response:(NSHTTPURLResponse *)response;
- (NSDictionary *)parseErrorCodeWithErrorData:(NSData *)errorData response:(NSHTTPURLResponse *)response;

@end
