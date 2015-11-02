//
//  ContentCell.m
//  微内涵
//
//  Created by mac on 15/10/27.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ContentCell.h"

@implementation ContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(VideoModel *)model
{
    if (_model !=model )
    {
        _model = model;
       
        _contentLable.text = _model.wbody;
        _contentLable.font = [UIFont systemFontOfSize:16 weight:3];
        _contentLable.textColor = [UIColor whiteColor];
        
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
