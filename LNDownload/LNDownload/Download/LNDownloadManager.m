//
//  LNDownloadManager.m
//  LNDownload
//
//  Created by 李能 on 15/11/3.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import "LNDownloadManager.h"
#import "LNDownloader.h"
@interface LNDownloadManager()

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
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.downloadQueue = [[NSOperationQueue alloc] init];
        self.downloadQueue.maxConcurrentOperationCount = 3;
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Download"];
        self.defaultDowmloadPath = [self creatDefaultDownloadPathIfNotExist:path];

    }
    return self;
}

- (LNDownloader *)downloadWithURL:(NSURL *)url
                     downloadPath:(NSString *)path
{
    NSString *downloadPath = path ? path:self.defaultDowmloadPath;
    LNDownloader *downloader = [[LNDownloader alloc] initWithDownloadURL:url
                                                            downloafPath:downloadPath];
    [self.downloadQueue addOperation:downloader];
    return downloader;
    
}
- (LNDownloader *)downloadWithURL:(NSURL *)url
                       customPath:(NSString *)customPathOrNil
                         progress:(void (^)(int64_t, int64_t))progressBlock
                            error:(void (^)(NSError *))errorBlock
                         complete:(void (^)(BOOL, NSURLSessionDownloadTask *))completeBlock
{
     NSString *downloadPath = customPathOrNil ? customPathOrNil:self.defaultDowmloadPath;
    LNDownloader *downloader = [[LNDownloader alloc] initWithDownloadURL:url
                                                            downloafPath:downloadPath progress:progressBlock
                                                                   error:errorBlock
                                                                complete:completeBlock];
    [self.downloadQueue addOperation:downloader];
    return downloader;
}

- (void)startDownload:(LNDownloader *)downloader
{
    [self.downloadQueue addOperation:downloader];
}

- (void)cancelAllDownloadsAndRemoveFiles:(BOOL)remove
{
    for (LNDownloader *downloader in [self.downloadQueue operations])
    {
        [downloader cancelDownloaderAndRemoveFile:remove];
    }
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
