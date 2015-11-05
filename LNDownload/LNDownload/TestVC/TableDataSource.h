//
//  TableDataSource.h
//  LNDownload
//
//  Created by 李能 on 15/11/5.
//  Copyright © 2015年 Lee. All rights reserved.
//

typedef void(^TableCellConfigureBlock)(id cell, id item);

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TableDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithItems:(NSArray *)items
              cellIndentifier:(NSString *)cellIndentifier
               configureBlock:(TableCellConfigureBlock)cellConfigureBlock;

- (id)itemAtIndex:(NSIndexPath *)indexPath;

@end
