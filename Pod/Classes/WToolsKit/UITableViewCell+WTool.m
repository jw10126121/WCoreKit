//
//  UITableViewCell+WTool.m
//
//
//  Created by Linjw on 13-12-17.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import "UITableViewCell+WTool.h"

@implementation UITableViewCell (WTool)

-(void)wSetLayoutMargins:(UIEdgeInsets)edge
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:edge];
    }
#endif
}


-(UITableView *)wTableViewFromCell
{
    UITableView * tableView = nil;
    UIView * superV = self.superview;
    
    while (superV)
    {
        if ([superV isKindOfClass:[UITableView class]])
        {
            tableView = (UITableView *)superV;
            break;
        }
        superV = superV.superview;
    }
    
//    BOOL ios7OrLater = ([UIDevice currentDevice].systemVersion.floatValue>=7.0);
//    superV = ios7OrLater?self.superview.superview:self.superview;
//    if ([superV isKindOfClass:[UITableView class]]) {
//        tableView = (UITableView *)superV;
//    }
    return tableView;
}

+(instancetype)wCellOnTableView:(UITableView *)tableView
                      IndexPath:(NSIndexPath *)indexPath
                  ConfigCellBlk:(void(^)(UITableViewCell * cell))ConfigCellBlk
{
    
    NSString * idCell = NSStringFromClass([self class]);
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    if (cell == nil)
    {
        cell = [[[self class] alloc]initWithStyle:0 reuseIdentifier:idCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (ConfigCellBlk) {      ConfigCellBlk(cell);    }
    }
    return cell;
}


/*!
 *  获取重用cell,如果不存在就创建
 *
 *  @param tableView tableView
 *  @param cellId    cellID
 *  @param cellStyle cellStyle
 *
 *  @return 重用cell
 */
+ (instancetype)wCellWithTableView:(UITableView*)tableView
                    CellIdentifier:(NSString *)cellId
                TableViewCellStyle:(UITableViewCellStyle)cellStyle
{
    if (!cellId)
    {
        cellId = NSStringFromClass([self class]);
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
#if __has_feature(objc_arc)
        cell = [[[self class]  alloc] initWithStyle:cellStyle reuseIdentifier:cellId];
#else
        cell = [[[[self class]  alloc] initWithStyle:cellStyle reuseIdentifier:cellId] autorelease];
#endif
    }
    return cell;
}



/**
 *  以类名当ReuseID
 */
+(NSString *)wReuseIdentifierWithClass {
    return NSStringFromClass([self class]);
}

+(UITableViewCell *)wDefaultCellOnTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    NSString * idCell = NSStringFromClass([self class]);
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    if (cell == nil)
    {
        cell = [[[self class] alloc]initWithStyle:0 reuseIdentifier:idCell];
    }
    return cell;
}

@end
