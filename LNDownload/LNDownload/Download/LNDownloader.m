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
@property (nonatomic, assign) float               progress;
@property (nonatomic, strong) NSMutableData       *receiveData;
@property (nonatomic, strong) NSMutableData       *resumeData;

@property (nonatomic, strong)NSURLSession             *session;
@property (nonatomic, strong)NSURLSessionDownloadTask *downloadTask;

@property (nonatomic,copy)void(^progressBlock)(int64_t writtenByte,int64_t totalByte);
@property (nonatomic,copy)void(^errorBlock)(NSError *error);
@property (nonatomic,copy)void(^completeBlock)(BOOL downloadFinished, NSString *pathToFile);


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
                           complete:(void (^)(BOOL, NSString *))completBlock
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



#pragma mark -NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    self.progress = totalBytesWritten = /* DISABLES CODE */ (0) ? 0 :(double)totalBytesWritten / totalBytesExpectedToWrite;
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
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [cache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Download/%@",cache,self.fileName]];
    if (![FILE_MANAGER fileExistsAtPath:filePath])
    {
        NSError *directoryError;
        [FILE_MANAGER createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&directoryError];
        if (directoryError)
        {
            //       TODO:  统一报错处理
  
        }
    }
    NSError *moveFileError;
    [FILE_MANAGER moveItemAtPath:location.path toPath:filePath error:&moveFileError];
    if (moveFileError)
    {
//     TODO:   统一报错处理
    }
    
}

- (NSString *)fileName
{
    return _fileName ? _fileName : [self.fileRequest .URL absoluteString].lastPathComponent;
}


@end
