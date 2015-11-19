//
//  LNDownloader.h
//  LNDownload
//
//  Created by 李能 on 15/11/3.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, DownloadState){
    
    DownloadState_Ready = 0,
    
    DownloadState_Suspend,
    
    DownloadState_Doing,
    
    DownloadState_Success,
    
    DownloadState_Cancel,
    
    DownloadState_Fail,
};

@protocol LNDownloaderDelegate ;

@interface LNDownloader : NSOperation

@property (nonatomic, weak)id<LNDownloaderDelegate>delegate;
@property (nonatomic, assign,readonly) DownloadState state;

@property (nonatomic, assign,readonly) float downloadRate;

@property (nonatomic, assign,readonly) float progress;

@property (nonatomic, copy, readonly)NSURL *downloadURL;

@property (nonatomic, copy, readonly)NSString *downloadPath;

@property (nonatomic, copy, readonly)NSString *filePath;
@property (nonatomic, copy, readwrite)NSString *fileName;

@property (nonatomic, strong, readonly) NSMutableURLRequest *fileRequest;

@property (readonly,getter=isSuspend) BOOL isSuspend;


/*
 
 利用代理回调的初始化方式；
 
 */

- (instancetype) initWithDownloadURL:(NSURL *)url
                        downloafPath:(NSString *)path;

/*
 
 block回调的初始化方式；
 
 */

- (instancetype) initWithDownloadURL:(NSURL *)url
                        downloafPath:(NSString *)path
                            progress:(void (^)(int64_t writtenByte,int64_t totalByte,float progress))progress
                               error:(void (^)(NSError *error))error
                            complete:(void (^)(BOOL downloadFinished, NSURLSessionDownloadTask *task))completBlock;



- (void)cancelDownloaderAndRemoveFile:(BOOL)remove;

- (void)pause;

- (void)resume;

@end






/*
       LNDownloadManager默认实现下列代理方法（以通知的方式通信），VC也可以单独实现
 */

@protocol LNDownloaderDelegate <NSObject>
//提供下载进度
- (void)download:(LNDownloader *)downloader
        progress:(float)progress;

//下载失败
- (void)download:(LNDownloader *)downloader
didStopWithError:(NSError *)error;

//下载成功返回下载地址
- (void)download:(LNDownloader *)downloader
didFinishWithSuccess:(BOOL)downloadFinished
          atPath:(NSString *)pathToFile;
@end


