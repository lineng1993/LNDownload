//
//  DownloadCell.m
//  LNDownload
//
//  Created by 李能 on 15/11/5.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import "DownloadCell.h"
#import "LNDownloadManager.h"
@interface DownloadCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadRate;
@property (weak, nonatomic) IBOutlet UILabel *downloadState;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@end

@implementation DownloadCell

- (void)awakeFromNib {
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailed:) name:DownloadFailed object:self.downloader];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloafProgressChanged:) name:DownloadProgressChanged object:self.downloader];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadSucess:) name:DownloadSucess object:self.downloader];

}

- (IBAction)downloadClick:(UIButton *)sender
{
    
    if (self.downloader.state == DownloadState_Ready)
    {
        [[LNDownloadManager sharedInstance] startDownload:self.downloader];
    }else if (self.downloader.state == DownloadState_Success)
    {
        NSLog(@"该任务已经下载，地址%@",self.downloader.downloadPath);
    }
    else if (self.downloader.state == DownloadState_Fail)
    {
        [[LNDownloadManager sharedInstance] rDoAndownloadTask:self.downloader];
        
    }else if(self.downloader.state == DownloadState_Doing){
        [self.downloadButton setTitle:@"继续" forState:UIControlStateNormal];
        [self.downloader pause];
        
    }else if (self.downloader.state == DownloadState_Suspend)
    {
        [self.downloadButton setTitle:@"暂停" forState:UIControlStateNormal];
        [self.downloader resume];
        
    }
    
}

- (void)setDownloader:(LNDownloader *)downloader
{
    _downloader = downloader;
    self.nameLabel.text = downloader.fileName;
    self.downloadRate.text = @"0.00";
    self.downloadState.text = @"等待中";
   
}

- (void)downloafProgressChanged:(NSNotification *)noti
{
    if (noti.object == self.downloader)
    {
        self.downloadRate.text = [NSString stringWithFormat:@"%.2f%%",[noti.userInfo[@"progress"] floatValue] * 100];
        self.downloadState.text = @"下载中";
       
    }
   
}

- (void)downloadFailed:(NSNotification *)noti
{
    if (noti.object == self.downloader)
    {
        NSLog(@"%@下载失败",self.downloader.fileName);
        self.downloadState.text = @"下载失败";
        [self.downloadButton setTitle:@"重新下载" forState:UIControlStateNormal];
    }
}

- (void)downloadSucess:(NSNotification *)noti
{
    if (noti.object == self.downloader)
    {
        self.downloadState.text = @"下载成功";
        [self.downloadButton setTitle:@"下载完成" forState:UIControlStateNormal];
        NSLog(@"%@下载完成，路径是 %@",self.downloader.fileName,noti.userInfo[@"path"]);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
