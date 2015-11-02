//
//  ContentCell.h
//  微内涵
//
//  Created by mac on 15/10/27.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
@interface ContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (nonatomic,strong) VideoModel*model;



@end
