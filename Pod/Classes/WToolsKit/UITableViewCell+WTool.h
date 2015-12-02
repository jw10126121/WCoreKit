//
//  UITableViewCell+WTool.h
//  
//
//  Created by Linjw on 13-12-17.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (WTool)


/**
 *  IOS8之后才有效
 */
-(void)wSetLayoutMargins:(UIEdgeInsets)edge;

/**
 *  得到cell所在的UITableView
 *
 *  @return UITableView
 */
-(UITableView *)wTableViewFromCell;

/**
 *  获取重用cell,如果不存在就创建
 *
 *  @param tableView     tableView
 *  @param indexPath     indexPath
 *  @param ConfigCellBlk Cell生成时回调
 */
+(instancetype)wCellOnTableView:(UITableView *)tableView
                      IndexPath:(NSIndexPath *)indexPath
                  ConfigCellBlk:(void(^)(UITableViewCell * cell))ConfigCellBlk;

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
                TableViewCellStyle:(UITableViewCellStyle)cellStyle;

/**
 *  以类名当ReuseID
 */
+(NSString *)wReuseIdentifierWithClass;

/**
 *  默认空Cell
 */
+(UITableViewCell *)wDefaultCellOnTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;


@end




