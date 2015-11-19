//
//  GCDDownloadManager.h
//  LNDownload
//
//  Created by 李能 on 15/11/17.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDDownloader.h"
@interface GCDDownloadManager : NSObject

+(GCDDownloadManager *)sharedManager;

//开始下载
- (void)startDownload:(GCDDownloader*)downloader;
//下载失败或者成功后重新下载
- (void)rDoAndownloadTask:(GCDDownloader *)downloader;

- (void)cancelAllDownloadsAndRemoveFiles:(BOOL)remove;
@end
