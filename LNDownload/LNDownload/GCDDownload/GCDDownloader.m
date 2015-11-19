//
//  GCDDownloader.m
//  LNDownload
//
//  Created by 李能 on 15/11/17.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import "GCDDownloader.h"


@interface GCDDownloader()
@property (nonatomic, strong) NSMutableURLRequest *fileRequest;
@property (nonatomic, copy)   NSURL               *downloadURL;
@property (nonatomic, copy)   NSString            *downloadPath;
@property (nonatomic, assign) DownloadState        state;
@property (nonatomic, assign) float               progress;
@property (nonatomic, strong) NSMutableData       *receiveData;
@property (nonatomic, strong) NSData       *resumeData;

@property (nonatomic, assign)int64_t                  writtenByte;
@property (nonatomic, assign)int64_t                  expectTotalByte;
@property (nonatomic, strong)NSURLSession             *session;
@property (nonatomic, strong)NSURLSessionDownloadTask *downloadTask;

@property (nonatomic,copy)void(^progressBlock)(int64_t writtenByte,int64_t totalByte,float progress);
@property (nonatomic,copy)void(^errorBlock)(NSError *error);
@property (nonatomic,copy)void(^completeBlock)(BOOL downloadFinished, NSURLSessionDownloadTask *task);


@end

@implementation GCDDownloader





@end
