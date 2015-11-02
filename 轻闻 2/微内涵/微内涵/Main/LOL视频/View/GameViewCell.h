//
//  GameViewCell.h
//  微内涵
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"
#import "UIKit+AFNetworking.h"
@interface GameViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *GameImge;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (nonatomic,strong) GameModel*model;

@end
