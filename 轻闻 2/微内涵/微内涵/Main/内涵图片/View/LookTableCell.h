//
//  LookTableCell.h
//  微内涵
//
//  Created by mac on 15/10/24.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookModel.h"
#import "UIKit+AFNetworking.h"
@interface LookTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *picImage;
@property (nonatomic,strong) LookModel*model;

@end
