//
//  ZBRequestEngine.h
//  BaseProject
//
//  Created by bigfish on 2018/11/1.
//  Copyright © 2018 bigfish. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "ZBRequestConst.h"

/*
 Hard setting:
 1. The data returned by the server must be binary
 2. Certificate Settings
 3. Open chrysanthemum
 */
@interface ZBRequestEngine : AFHTTPSessionManager

+ (instancetype)defaultEngine;

/**
 Initiating network request
 
 @param request ZBURLRequest
 @param zb_progress progress
 @param success Success callback
 @param failure Failure callback
 @return task
 */
- (NSURLSessionDataTask *)dataTaskWithMethod:(ZBURLRequest *)request
                                 zb_progress:(void (^)(NSProgress * _Nonnull))zb_progress
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Upload file
 
 @param request ZBURLRequest
 @param zb_progress progress
 @param success Success callback
 @param failure Failure callback
 @return task
 */
- (NSURLSessionDataTask *)uploadWithRequest:(ZBURLRequest *)request
                                zb_progress:(void (^)(NSProgress * _Nonnull))zb_progress
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Download file
 
 @param request ZBURLRequest
 @param downloadProgressBlock progress
 @param completionHandler callback
 @return task
 */
- (NSURLSessionDownloadTask *)downloadWithRequest:(ZBURLRequest *)request
                                         progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

/**
 Cancel request task
 
 @param urlString           Protocol interfaces
 */
- (void)cancelRequest:(NSString *)urlString  completion:(cancelCompletedBlock)completion;


@end


