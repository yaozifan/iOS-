//
//  LookTable.h
//  微内涵
//
//  Created by mac on 15/10/24.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LookDtailBlock) (NSString*);
@interface LookTable : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,copy) NSString*channelId;
@property (nonatomic,copy) NSString*title;
@property (nonatomic,copy) NSString*source;//来源
@property (nonatomic,copy) NSString*pubDate;//时间
@property (nonatomic,copy) NSString*link;//网址
@property (nonatomic,strong) NSMutableArray*dataArray;
@property (nonatomic,strong) NSArray*scrollArray;
@property (nonatomic,assign) NSInteger channel;

@property (nonatomic,copy) LookDtailBlock detail;
@property (nonatomic,copy) LookDtailBlock scrollDetail;


@end
