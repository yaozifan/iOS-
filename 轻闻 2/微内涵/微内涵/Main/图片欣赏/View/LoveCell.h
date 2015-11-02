//
//  LoveCell.h
//  微内涵
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoveModel.h"
#import "UIKit+AFNetworking.h"
@interface LoveCell : UITableViewCell




@property (weak, nonatomic) IBOutlet UIImageView *LoveimageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (nonatomic,strong) LoveModel *model;
@property (weak, nonatomic) IBOutlet UILabel *acsessLable;

@end
