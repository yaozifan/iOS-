//
//  MovieCell.h
//  微内涵
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"
#import "UIImageView+AFNetworking.h"
@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *conutLable;

@property (nonatomic,strong) MovieModel*model;

@end
