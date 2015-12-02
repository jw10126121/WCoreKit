//
//  UserLocationMdl.h
//  LeRead
//
//  Created by 林锦乾 on 15/11/13.
//  Copyright © 2015年 ljw. All rights reserved.
//

//#import "BaseModel.h"
#import "WOrmBaseModel.H"
/**
 *  用户定位模型
 */
@interface UserLocationMdl : WOrmBaseModel

@property(nonatomic,assign)NSInteger number;     //第N个常用数据
@property (nonatomic,assign)NSInteger userId;    //用户id
@property (nonatomic,assign)CGFloat latitude;    //纬度
@property (nonatomic,assign)CGFloat longitude;   //经度

@end
