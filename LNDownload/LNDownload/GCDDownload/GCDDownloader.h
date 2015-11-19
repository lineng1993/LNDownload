//
//  GCDDownloader.h
//  LNDownload
//
//  Created by 李能 on 15/11/17.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNDownloader.h"


@protocol GCDDownloaderDelegate;

@interface GCDDownloader : NSObject


@property (nonatomic, weak)id<GCDDownloaderDelegate>delegate;

@property (nonatomic, assign,readonly) DownloadState state;

@property (nonatomic, assign,readonly) float downloadRate;

@property (nonatomic, assign,readonly) float progress;

@property (nonatomic, copy, readonly)NSURL *downloadURL;

@property (nonatomic, copy, readonly)NSString *downloadPath;

@property (nonatomic, copy, readonly)NSString *filePath;
@property (nonatomic, copy, readwrite)NSString *fileName;

@property (nonatomic, strong, readonly) NSMutableURLRequest *fileRequest;

@property (readonly,getter=isSuspend) BOOL isSuspend;
@property (readonly, getter=isExecuting) BOOL executing;
@property (readonly, getter=isFinished) BOOL finished;
@property (readonly, getter=isReady) BOOL ready;
@property (readonly, getter=isCancelled) BOOL cancelled;


- (void)cancelDownloaderAndRemoveFile:(BOOL)remove;

- (void)pause;

- (void)resume;
@end


@protocol GCDDownloaderDelegate <NSObject>



@end
