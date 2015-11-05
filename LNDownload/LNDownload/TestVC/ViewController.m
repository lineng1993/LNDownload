//
//  ViewController.m
//  LNDownload
//
//  Created by 李能 on 15/11/3.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import "ViewController.h"
#import "TableDataSource.h"
#import "LNDownloader.h"
#import "LNDownloadManager.h"
#import "DownloadCell.h"
static NSString *const URL = @"url";
static NSString *const cellIndentifier = @"DownloadCell";
@interface ViewController ()<UITableViewDelegate>
{
    NSString *path;
    LNDownloadManager *manager;
    UITableView *tableView;
    NSMutableArray *downloadArray;
    
}

@property (nonatomic, strong) TableDataSource *tableDataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    [self setupTableView];
}

- (void)setupTableView
{
    
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [tableView registerNib:[UINib nibWithNibName:cellIndentifier bundle:nil] forCellReuseIdentifier:cellIndentifier];
    tableView.rowHeight = 100;
    tableView.delegate = self;
    tableView.dataSource = self.tableDataSource;
    [self.view addSubview:tableView];
    
}
- (void)setupDataSource
{
    path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Download"];
    LNDownloader *downloader1 = [[LNDownloader alloc] initWithDownloadURL:[NSURL URLWithString:@"http://cloud.video.taobao.com/play/u/2365441852/p/1/e/6/t/1/30655046.mp4"] downloafPath:path];
    LNDownloader *downloader2 = [[LNDownloader alloc] initWithDownloadURL:[NSURL URLWithString:@"http://cloud.video.taobao.com/play/u/2365441852/p/1/e/6/t/1/30655047.mp4"] downloafPath:path];
    LNDownloader *downloader3 = [[LNDownloader alloc] initWithDownloadURL:[NSURL URLWithString:@"http://cloud.video.taobao.com/play/u/2365441852/p/1/e/6/t/1/30655045.mp4"] downloafPath:path];
    NSArray *array = @[downloader3,downloader1,downloader2];
    TableCellConfigureBlock configureCell = ^(DownloadCell *cell,LNDownloader *downloader){
        [cell setDownloader:downloader];
    };
    self.tableDataSource = [[TableDataSource alloc] initWithItems:array
                                                  cellIndentifier:cellIndentifier
                                                   configureBlock:configureCell];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
