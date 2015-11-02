//
//  LoveCell.m
//  微内涵
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LoveCell.h"

@implementation LoveCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(LoveModel *)model
{
    if (_model!= model) {
        _model = model;
        
        _contentLable.text = _model.title;
        NSString*thumb = _model.picUrl;
        [_LoveimageView setImageWithURL:[NSURL URLWithString:thumb]];
        
        NSString*account = [NSString stringWithFormat:@"来源:%@",_model.descriptionID];
        
        _acsessLable.text = account;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
