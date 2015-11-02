//
//  LookTableCell.m
//  微内涵
//
//  Created by mac on 15/10/24.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LookTableCell.h"

@implementation LookTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(LookModel *)model
{
    if (_model != model)
    {
        _model = model;
        
        _titleLable.text = _model.title;
        
        NSString*str = _model.picUrl;
        
        [_picImage setImageWithURL:[NSURL URLWithString:str]];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
