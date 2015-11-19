//
//  GCDDownloadManager.m
//  LNDownload
//
//  Created by 李能 on 15/11/17.
//  Copyright © 2015年 Lee. All rights reserved.
//
#define MaxTaskSemaphore 3
#import "GCDDownloadManager.h"


NSString *const DownloaderCountChanged = @"DownloaderCountChanged";

@interface GCDDownloadManager()


@property (nonatomic, strong) dispatch_semaphore_t maxTaskSemaphore;

@property (nonatomic, strong)NSMutableArray *taskArray;

@end


@implementation GCDDownloadManager

+ (GCDDownloadManager *)sharedManager
{
    static dispatch_once_t once;
    static GCDDownloadManager *manager = nil;
    dispatch_once(&once, ^{
        if (!manager) {
            manager = [[GCDDownloadManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _maxTaskSemaphore = dispatch_semaphore_create(MaxTaskSemaphore);
        _taskArray        = [NSMutableArray array];
    }
    return self;
}


- (void)startDownload:(GCDDownloader *)downloader
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DownloaderCountChanged object:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(_maxTaskSemaphore, DISPATCH_TIME_FOREVER);
        [self excuteDownload:downloader];
    });
}
/**GCD实现原理基本一样，不在重复写了，一个任务完成时只需要
 *     dispatch_async(dispatch_get_global_queue(0, 0), ^{
 *         dispatch_semaphore_signal(_maxTaskSemaphore);
 *  });
 * 开启下一个任务，
 *
 *
 */
- (void)excuteDownload:(GCDDownloader *)downloader
{
    [downloader resume];
    
}








@end
