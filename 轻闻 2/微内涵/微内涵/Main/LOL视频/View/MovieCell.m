//
//  MovieCell.m
//  微内涵
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    // Initialization code
      NSString*image = _model.vpic_small;
    
        [_movieImage setImageWithURL:[NSURL URLWithString:image]];

}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        
        
        
        
    }
    
    
    return self;
    
}

- (void)setModel:(MovieModel *)model
{
    if (_model != model) {

        _model = model;
        _titleLable.text = _model.wbody;
        
        NSString*like = [NSString stringWithFormat:@"👍%@",_model.likes];
        
        _conutLable.text = like;
        
        NSString*image = _model.vpic_small;
        
        [_movieImage setImageWithURL:[NSURL URLWithString:image]];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
