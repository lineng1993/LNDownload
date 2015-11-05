//
//  DownloadCell.h
//  LNDownload
//
//  Created by 李能 on 15/11/5.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNDownloader.h"
@interface DownloadCell : UITableViewCell

@property (nonatomic, strong) LNDownloader *downloader;

@end
