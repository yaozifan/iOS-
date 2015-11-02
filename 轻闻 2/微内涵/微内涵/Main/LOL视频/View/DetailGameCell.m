//
//  DetailGameCell.m
//  微内涵
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "DetailGameCell.h"

@implementation DetailGameCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(DetailModel *)model
{
    if (_model!=model) {
        
        _model = model;
        
        
        NSString *time = [NSString stringWithFormat:@"视频：%@",_model.time];
        NSString*date = [NSString stringWithFormat:@"更新：%@",_model.date];
        
        _dateLable.text = date;
        _timeLable.text = time;
        _titleName.text = _model.title;

        NSString*str = _model.thumb;
        [_thumbImage setImageWithURL:[NSURL URLWithString:str]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
