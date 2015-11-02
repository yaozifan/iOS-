//
//  MovieModel.h
//  微内涵
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseModel.h"

@interface MovieModel : BaseModel
@property (copy,nonatomic) NSString *wbody;//文本
@property (copy,nonatomic) NSString *vplay_url;//视频链接
@property (copy,nonatomic) NSString *vpic_small;//图片
@property (copy,nonatomic) NSString *likes;//喜欢的人，点赞的

@end
