//
//  VideoModel.h
//  微内涵
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseModel.h"

@interface VideoModel : BaseModel
@property (copy,nonatomic) NSNumber *wpic_s_height;
@property (copy,nonatomic) NSNumber *wpic_m_height;



@property (copy,nonatomic) NSString *wpic_m_width;
@property (copy,nonatomic) NSString *wbody;

@property (copy,nonatomic) NSNumber *wpic_small;
@property (copy,nonatomic) NSNumber *wpic_s_width;

@property (copy,nonatomic) NSString *wpic_middle;
@property (copy,nonatomic) NSString *is_gif;
@property (copy,nonatomic) NSString *wpic_large;
@property (copy,nonatomic) NSString *wid;
@property (copy,nonatomic) NSString *comments;
@property (copy,nonatomic) NSString *update_time;
@property (copy,nonatomic) NSString *likes;


@property(copy,nonatomic)NSNumber *type;

@end
