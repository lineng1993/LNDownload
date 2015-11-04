//
//  ViewController.m
//  LNDownload
//
//  Created by 李能 on 15/11/3.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import "ViewController.h"
#import "LNDownloader.h"
#import "LNDownloadManager.h"
@interface ViewController ()
{
    NSString *path;
    LNDownloadManager *manager;
    
}

@property (weak, nonatomic) IBOutlet UIProgressView *progress1;
@property (weak, nonatomic) IBOutlet UIProgressView *progress2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Download"];

//    http://120.25.226.186:32812/resources/videos/minion_01.mp4
    
    manager = [LNDownloadManager sharedInstance];
   
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)download1:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://cloud.video.taobao.com/play/u/2365441852/p/1/e/6/t/1/30655046.mp4"];
    LNDownloader *downloader = [[LNDownloader alloc] initWithDownloadURL:url downloafPath:path];
    _progress1.progress = downloader.progress;
    [manager startDownload:downloader];
  
}
- (IBAction)dowmload2:(id)sender
{
    NSURL *url1 = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
 
    [manager downloadWithURL:url1 customPath:path progress:^(int64_t receivedLength, int64_t totalLength) {
            _progress2.progress = (float)receivedLength / totalLength;
    } error:^(NSError *error) {
        
    } complete:^(BOOL downloadFinished, NSURLSessionDownloadTask *task) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
