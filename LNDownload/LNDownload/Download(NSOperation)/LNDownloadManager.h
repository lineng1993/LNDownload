//
//  LNDownloadManager.h
//  LNDownload
//
//  Created by 李能 on 15/11/3.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LNDownloader;
@protocol LNDownloaderDelegate;


static NSString *const DownloadStateChanged    = @"DownloadStateChanged";
static NSString *const DownloadProgressChanged = @"DownloadProgressChanged";
static NSString *const DownloadCountChanged    = @"DownloadCountChanged";
static NSString *const DownloadSucess          = @"DownloadSucess";
static NSString *const DownloadFailed          = @"DownloadFailed";
@interface LNDownloadManager : NSObject

@property (nonatomic, copy)NSString *defaultDowmloadPath;

@property (nonatomic, assign) NSUInteger maxDownloadCount;

@property (nonatomic, assign) NSUInteger currentDowmloadCount;


+ (instancetype)sharedInstance;

- (LNDownloader *)downloadWithURL:(NSURL *)url
                     downloadPath:(NSString *)path;


- (LNDownloader *)downloadWithURL:(NSURL *)url
                                customPath:(NSString *)customPathOrNil
                                  progress:(void (^)(int64_t receivedLength, int64_t totalLength,float progress))progressBlock
                                     error:(void (^)(NSError *error))errorBlock
                                  complete:(void (^)(BOOL downloadFinished, NSURLSessionDownloadTask *task))completeBlock;
//开始下载
- (void)startDownload:(LNDownloader*)downloader;
//下载失败或者成功后重新下载
- (void)rDoAndownloadTask:(LNDownloader *)downloader;

- (void)cancelAllDownloadsAndRemoveFiles:(BOOL)remove;

@end
