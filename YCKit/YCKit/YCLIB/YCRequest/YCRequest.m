//
//  YCRequest.m
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import "YCRequest.h"

#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"

@interface YCRequest ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *httpManager;

@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) NSString *serviceURL;

@property (strong, nonatomic) NSMutableDictionary *headers;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (strong, nonatomic) NSMutableArray *files;

@property (nonatomic) NSTimeInterval requestTime;
@property (nonatomic) NSTimeInterval completeTime;

@property (strong, nonatomic) AFHTTPRequestOperation *currentOperation;

@end

@implementation YCRequest

#pragma mark - Initialize

- (id)initWithBaseURL:(NSURL *)url method:(NSString *)method serviceURL:(NSString *)serviceURL
{
    
    self = [super init];
    
    if(self) {
        
        self.httpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
//        self.httpManager.requestSerializer = [AFJSONRequestSerializer new];
//        self.httpManager.responseSerializer = [AFHTTPResponseSerializer new];
        self.method = method;
        self.serviceURL = serviceURL;
    }
    
    return self;
}

- (void)setRequestSerializer:(id)type
{
    self.httpManager.requestSerializer = type;
    
}
- (void)setResponseSerializer:(id)type
{
    self.httpManager.responseSerializer = type;
}

#pragma mark - Parameters

- (void)addHeaderWithKey:(NSString *)key value:(NSString *)value {
    
    if(nil == self.headers) {
        self.headers = [NSMutableDictionary dictionary];
    }
    
    [self.headers setObject:value forKey:key];
}

- (void)addParamWithKey:(NSString *)key value:(id)value {
    
    if(nil == value) {
        return;
    }
    
    if(nil == self.parameters) {
        self.parameters = [NSMutableDictionary dictionary];
    }
    
    [self.parameters setObject:value forKey:key];
}

- (void)addFileWithFileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    
    if(nil == self.files) {
        self.files = [NSMutableArray array];
    }
    
    NSMutableDictionary *file = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 fileData, @"fileData",
                                 name, @"name",
                                 nil];
    
    if(fileName) {
        [file setObject:fileName forKey:@"fileName"];
    }
    
    if(mimeType) {
        [file setObject:mimeType forKey:@"mimeType"];
    }
    
    [self.files addObject:file];
}

#pragma mark - Request

- (void)request {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSError *error = nil;
    NSMutableURLRequest *request = nil;
    
    if(0 < self.files.count) {
        request = [self.httpManager.requestSerializer multipartFormRequestWithMethod:self.method
                                                                           URLString:[[NSURL URLWithString:self.serviceURL relativeToURL:self.httpManager.baseURL] absoluteString]
                                                                          parameters:self.parameters
                                                           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                               
                                                               for(NSDictionary *file in self.files) {
                                                                   [formData appendPartWithFileData:[file objectForKey:@"fileData"] name:[file objectForKey:@"name"] fileName:[file objectForKey:@"fileName"] mimeType:[file objectForKey:@"mimeType"]];
                                                               }
                                                           }
                                                                               error:&error];
    } else {
        
        NSLog(@"%@", self.parameters);
        request = [self.httpManager.requestSerializer requestWithMethod:self.method URLString:[[NSURL URLWithString:self.serviceURL relativeToURL:self.httpManager.baseURL] absoluteString] parameters:self.parameters error:&error];
    }
    
    if(error)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *result = @{@"error": error};
        self.failBlock(result);
    }
    else
    {
        if(0 < self.headers.count) {
            NSMutableDictionary *headerFields = [NSMutableDictionary dictionaryWithDictionary:request.allHTTPHeaderFields];
            [headerFields addEntriesFromDictionary:self.headers];
            
            [request setAllHTTPHeaderFields:headerFields];
        }
        
        AFHTTPRequestOperation *operation = [self.httpManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            self.completeTime = [NSDate date].timeIntervalSince1970;
            
            __block id result = nil;
            __block NSDictionary *error = nil;
            
            [self processResponseHeader:[operation.response allHeaderFields]];
            
            @try {
                result = [self parseContentWithResponseObject:responseObject response:operation.response];
            }
            @catch (NSException *exception) {
                error = @{@"exception": exception};
            }
            @finally {
                if (result) {
                    if(self.successBlock) {
                        self.successBlock(result);
                    }
                }
                else{
                    if(self.failBlock) {
                        error = @{@"exception": [NSException exceptionWithName:@"Parse Fail" reason:@"Parse Fail" userInfo:nil]};
                        self.failBlock(error);
                    }
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            self.completeTime = [NSDate date].timeIntervalSince1970;
            
            [self processResponseHeader:[operation.response allHeaderFields]];
            
            @try {
                
                NSData *errorData = [[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSDictionary *result = [self parseErrorCodeWithErrorData:errorData response:operation.response];
                
                if(self.failBlock) {
                    self.failBlock(result);
                }
            }
            @catch (NSException *exception) {
                
                if(self.failBlock) {
                    NSDictionary *result = @{@"exception": exception};
                    self.failBlock(result);
                }
            }
        }];
        
        self.currentOperation = operation;
        
        self.requestTime = [NSDate date].timeIntervalSince1970;
        
        [self.httpManager.operationQueue addOperation:operation];
    }
}

- (void)cancel {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.currentOperation cancel];
    self.currentOperation = nil;
}

#pragma mark - Getter

- (NSTimeInterval)elapsedTime {
    
    NSTimeInterval elapsedTime = self.completeTime - self.requestTime;
    
    return elapsedTime;
}

- (NSString *)contentMIMETypeForImageData:(NSData *)data {
    
    uint8_t byte;
    [data getBytes:&byte length:1];
    
    switch(byte) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    
    return nil;
}

#pragma mark - Parse

- (void)processResponseHeader:(NSDictionary *)headers {
    
}

- (id)parseContentWithResponseObject:(id)responseObject response:(NSHTTPURLResponse *)response {
    
    return responseObject;
}

- (NSDictionary *)parseErrorCodeWithErrorData:(NSData *)errorData response:(NSHTTPURLResponse *)response {
    
    return @{@"state": [NSNumber numberWithInteger:response.statusCode]};
}

@end
