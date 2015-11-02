//
//  VideoCell.m
//  微内涵
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "VideoCell.h"
#import "UIImageView+WebCache.h"
@implementation VideoCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatui];
    }
    
    return self;
}

- (void)creatui
{
    _wbodyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 280,30)];
    _wbodyLabel.font=[UIFont boldSystemFontOfSize:15];
    _wbodyLabel.numberOfLines=3;
    _wbodyLabel.textColor=[UIColor blackColor];
    [self.contentView addSubview:_wbodyLabel];
    
    _wpic_middleImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, 100)];
    [self.contentView addSubview:_wpic_middleImageView];
    
    _commentsLabel = [[UILabel alloc]initWithFrame:CGRectMake(300, 0, 30, 30)];
    _commentsLabel.textColor=[UIColor redColor];
    
    [self.contentView addSubview:_commentsLabel];
}


- (void)setModel:(VideoModel *)model
{
    if (_model != model)
    {
        _model = model;
        
        self.wbodyLabel.text = _model.wbody;
        [self.wpic_middleImageView sd_setImageWithURL:[NSURL URLWithString:_model.wpic_middle] placeholderImage:[UIImage imageNamed:@"12"]];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
