//
//  DetailModel.h
//  微内涵
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseModel.h"

@interface DetailModel : BaseModel

@property (copy,nonatomic) NSString *author;
@property (copy,nonatomic) NSString *thumb;
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *detailId;
@property (copy,nonatomic) NSString *time;
@property (copy,nonatomic) NSString *date;


@end
