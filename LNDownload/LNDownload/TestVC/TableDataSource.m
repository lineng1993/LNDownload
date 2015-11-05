//
//  TableDataSource.m
//  LNDownload
//
//  Created by 李能 on 15/11/5.
//  Copyright © 2015年 Lee. All rights reserved.
//

#import "TableDataSource.h"

@interface TableDataSource()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableCellConfigureBlock configureCellBlock;

@end


@implementation TableDataSource

- (instancetype)initWithItems:(NSArray *)items
              cellIndentifier:(NSString *)cellIndentifier
               configureBlock:(TableCellConfigureBlock)cellConfigureBlock
{
    if (self = [super init])
    {
        self.items = items;
        self.cellIdentifier = cellIndentifier;
        self.configureCellBlock = cellConfigureBlock;
    }
    return self;
}
- (id)itemAtIndex:(NSIndexPath *)indexPath
{
    return self.items[indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndex:indexPath];
    self.configureCellBlock(cell,item);
    return cell;
}
@end
