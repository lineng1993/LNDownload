//
//  LNDownloadManager.h
//  LNDownload
//
//  Created by 李能 on 15/11/3.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LNDownloader;
@interface LNDownloadManager : NSObject

@property (nonatomic, copy)NSString *defaultDowmloadPath;

@property (nonatomic, assign) NSUInteger maxDownloadCount;

@property (nonatomic, assign) NSUInteger currentDowmloadCount;


+ (instancetype)sharedInstance;

- (LNDownloader *)downloadWithURL:(NSURL *)url
                     downloadPath:(NSString *)path;


- (LNDownloader *)downloadWithURL:(NSURL *)url
                                customPath:(NSString *)customPathOrNil
                                  progress:(void (^)(int64_t receivedLength, int64_t totalLength))progressBlock
                                     error:(void (^)(NSError *error))errorBlock
                                  complete:(void (^)(BOOL downloadFinished, NSURLSessionDownloadTask *task))completeBlock;
- (void)startDownload:(LNDownloader*)downloader;


- (void)cancelAllDownloadsAndRemoveFiles:(BOOL)remove;

@end
