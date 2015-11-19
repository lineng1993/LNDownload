//
//  LNDownloadManager.m
//  LNDownload
//
//  Created by 李能 on 15/11/3.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import "LNDownloadManager.h"
#import "LNDownloader.h"



@interface LNDownloadManager()<LNDownloaderDelegate>

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end


@implementation LNDownloadManager

+(instancetype)sharedInstance
{
    static LNDownloadManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!manager)
        {
            manager = [[[self class] alloc] init];
        }
    });
    return manager;
}

#pragma mark  Init
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.downloadQueue = [[NSOperationQueue alloc] init];
        self.downloadQueue.maxConcurrentOperationCount = 1;
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Download"];
        self.defaultDowmloadPath = [self creatDefaultDownloadPathIfNotExist:path];

    }
    return self;
}

#pragma mark public Method
- (LNDownloader *)downloadWithURL:(NSURL *)url
                     downloadPath:(NSString *)path
                        
{
    NSString *downloadPath = path ? path:self.defaultDowmloadPath;
    LNDownloader *downloader = [[LNDownloader alloc] initWithDownloadURL:url
                                                            downloafPath:downloadPath];
    downloader.delegate = self;
    [self.downloadQueue addOperation:downloader];
    return downloader;
    
}
- (LNDownloader *)downloadWithURL:(NSURL *)url
                       customPath:(NSString *)customPathOrNil
                         progress:(void (^)(int64_t, int64_t,float))progressBlock
                            error:(void (^)(NSError *))errorBlock
                         complete:(void (^)(BOOL, NSURLSessionDownloadTask *))completeBlock
{
     NSString *downloadPath = customPathOrNil ? customPathOrNil:self.defaultDowmloadPath;
    LNDownloader *downloader = [[LNDownloader alloc] initWithDownloadURL:url
                                                            downloafPath:downloadPath
                                                                progress:progressBlock
                                                                   error:errorBlock
                                                                complete:completeBlock];
    downloader.delegate = self;
    [self.downloadQueue addOperation:downloader];
    return downloader;
}

- (void)startDownload:(LNDownloader *)downloader
{
    downloader.delegate = self;
    [self.downloadQueue addOperation:downloader];
}

- (void)cancelAllDownloadsAndRemoveFiles:(BOOL)remove
{
    for (LNDownloader *downloader in [self.downloadQueue operations])
    {
        downloader.delegate = nil;
        [downloader cancelDownloaderAndRemoveFile:remove];
    }
}

- (void)rDoAndownloadTask:(LNDownloader *)downloader
{
    [downloader cancelDownloaderAndRemoveFile:YES];
    [self startDownload:downloader];
    
}
- (NSUInteger) currentDowmloadCount
{
    NSUInteger count = 0;
    for (LNDownloader *downloader in [self.downloadQueue operations])
    {
        if (downloader.state == DownloadState_Doing) {
            count ++;
        }
    }
    return count;
}

#pragma mark   LNDownnloaderDelegate
- (void)download:(LNDownloader *)downloader progress:(float)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloadStateChanged object:downloader];
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloadProgressChanged object:downloader userInfo:@{@"progress":@(progress)}];
    });
    
}

- (void)download:(LNDownloader *)downloader didStopWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloadFailed object:downloader];
    });
}

- (void)download:(LNDownloader *)downloader didFinishWithSuccess:(BOOL)downloadFinished atPath:(NSString *)pathToFile
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloadSucess object:downloader userInfo:@{@"path":pathToFile}];
    });}


#pragma mark private
- (NSString *)creatDefaultDownloadPathIfNotExist:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return path;
    }
    else
    {
        [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
@end
