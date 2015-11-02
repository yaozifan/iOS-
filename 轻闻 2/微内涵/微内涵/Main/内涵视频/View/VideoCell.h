//
//  VideoCell.h
//  微内涵
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
@interface VideoCell : UITableViewCell

@property (copy,nonatomic) UIImageView *wpic_middleImageView;
@property (copy,nonatomic) UILabel *wbodyLabel;
@property (copy,nonatomic) UILabel *commentsLabel;

@property (nonatomic,strong) VideoModel*model;

@end
