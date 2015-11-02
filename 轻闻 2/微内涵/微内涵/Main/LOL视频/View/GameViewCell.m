//
//  GameViewCell.m
//  微内涵
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "GameViewCell.h"

@implementation GameViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(GameModel *)model
{
    if (_model != model)
    {
        _model = model;
        
        _nameLable.text = _model.name;
        
        NSString*image = _model.icon;
        
        [_GameImge setImageWithURL:[NSURL URLWithString:image]];
        
        //单元格的弧度
        _GameImge.layer.cornerRadius=20;
        //超出单元格部分截取
        _GameImge.layer.masksToBounds=YES;
        //设置单元格边框的颜色
        _GameImge.layer.borderColor=[UIColor grayColor].CGColor;
        //边框的宽度
        _GameImge.layer.borderWidth=2;


    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
