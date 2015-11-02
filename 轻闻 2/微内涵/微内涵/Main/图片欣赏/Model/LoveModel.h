//
//  LoveModel.h
//  微内涵
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseModel.h"

@interface LoveModel : BaseModel

/*
  */
@property (nonatomic,copy) NSString*descriptionID;//来源
@property (nonatomic,copy) NSString*title;
@property (nonatomic,copy) NSString*picUrl;//照片
@property (nonatomic,copy) NSString*url;
//@property (nonatomic,copy) NSString*read_num;//阅读数

@end
