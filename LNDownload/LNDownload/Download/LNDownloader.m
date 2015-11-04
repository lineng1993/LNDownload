//
//  LNDownloader.m
//  LNDownload
//
//  Created by 李能 on 15/11/3.
//  Copyright © 2015年 Lee. All rights reserved.
//


#define FILE_MANAGER   [NSFileManager defaultManager]
#import "LNDownloader.h"


@interface LNDownloader()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSMutableURLRequest *fileRequest;
@property (nonatomic, copy)   NSURL               *downloadURL;
@property (nonatomic, copy)   NSString            *downloadPath;
@property (nonatomic, assign) DownloadState        state;
@property (nonatomic, strong) NSNumber            *progress;
@property (nonatomic, strong) NSMutableData       *receiveData;
@property (nonatomic, strong) NSMutableData       *resumeData;

@property (nonatomic, assign)int64_t                  writtenByte;
@property (nonatomic, assign)int64_t                  expectTotalByte;
@property (nonatomic, strong)NSURLSession             *session;
@property (nonatomic, strong)NSURLSessionDownloadTask *downloadTask;

@property (nonatomic,copy)void(^progressBlock)(int64_t writtenByte,int64_t totalByte);
@property (nonatomic,copy)void(^errorBlock)(NSError *error);
@property (nonatomic,copy)void(^completeBlock)(BOOL downloadFinished, NSURLSessionDownloadTask *task);


@end



@implementation LNDownloader

#pragma mark  init
- (instancetype)initWithDownloadURL:(NSURL *)url
                       downloafPath:(NSString *)path
{
    self = [super init];
    if (self)
    {
        self.downloadURL = url;
        self.state = DownloadState_Ready;
        self.downloadPath = path;
        self.fileRequest = [[NSMutableURLRequest alloc] initWithURL:url
                                                        cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    }
    return self;
}

- (instancetype)initWithDownloadURL:(NSURL *)url
                       downloafPath:(NSString *)path
                           progress:(void (^)(int64_t, int64_t))progress
                              error:(void (^)(NSError *))error
                           complete:(void (^)(BOOL, NSURLSessionDownloadTask *))completBlock
{
    self = [self initWithDownloadURL:url downloafPath:path];
    if (self)
    {
        self.progressBlock = progress;
        self.errorBlock    = error;
        self.completeBlock = completBlock;
    }
    return self;
}


- (void)start
{
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                      delegate:self
                                                 delegateQueue:nil];
    self.downloadTask = [self.session downloadTaskWithRequest:self.fileRequest];
    [self.downloadTask resume];
}

- (BOOL)isExecuting
{
    return self.state == DownloadState_Doing;
}

- (BOOL)isCancelled
{
    return self.state == DownloadState_Cancel;
}

- (BOOL)isFinished
{
    return self.state == DownloadState_Success;
}


#pragma mark -NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    self.writtenByte = totalBytesWritten;
    self.expectTotalByte = totalBytesExpectedToWrite;
    self.state = DownloadState_Doing;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.progressBlock) {
            self.progressBlock(totalBytesWritten,totalBytesExpectedToWrite);
        }
    });
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSString *filePath = [self.downloadPath stringByAppendingPathComponent:self.fileName];
    if (![FILE_MANAGER fileExistsAtPath:self.downloadPath])
    {
        NSError *directoryError;
        [FILE_MANAGER createDirectoryAtPath:self.downloadPath withIntermediateDirectories:YES attributes:nil error:&directoryError];
        if (directoryError)
        {
            [self downloadWithError:directoryError task:self.downloadTask];
            return;
        }
    }
    if ([FILE_MANAGER fileExistsAtPath:filePath])
    {
        [FILE_MANAGER removeItemAtPath:filePath error:nil];
    }
    NSError *moveFileError;
    [FILE_MANAGER moveItemAtPath:location.path toPath:filePath error:&moveFileError];
    if (moveFileError)
    {
        [self downloadWithError:moveFileError task:self.downloadTask];
    }
    else
        
    {
        [self downloadWithError:nil task:self.downloadTask];
        NSLog(@"下载完成，路径%@",self.downloadPath);
    }
    
    
    
}
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if (error)
    {
         [self downloadWithError:error task:self.downloadTask];
    }
   
}


- (void)downloadWithError:(NSError *)error task:(NSURLSessionDownloadTask *)task
{
    if (error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.errorBlock)
            {
                self.errorBlock(error);
            }
        });
    }
    BOOL success = error == nil;
 
  
    dispatch_async(dispatch_get_main_queue(), ^{
            
        if (self.completeBlock)
        {
            self.completeBlock(success,task);
        }
    });

    DownloadState state = success ? DownloadState_Success :DownloadState_Fail;
    [self cancelAndSetDownloadStateWhenDownloadFinish:state];
}

- (void)cancelAndSetDownloadStateWhenDownloadFinish:(DownloadState)state
{
    [self.downloadTask cancel];
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    self.state = state;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}
- (void)cancelDownloaderAndRemoveFile:(BOOL)remove
{
    
}
- (NSString *)fileName
{
    return _fileName ? _fileName : [self.fileRequest .URL absoluteString].lastPathComponent;
}




@end
