//
//  ZDDCommentModel.h
//  HAHA
//
//  Created by Maker on 2019/3/30.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMHLSubCommentsModel.h"
#import <YYModel/YYModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZDDCommentModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *target_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_date;
@property (nonatomic, strong) GODUserModel *user;

@property (nonatomic, strong) NSArray<YMHLSubCommentsModel *> *subcomments;
@property (nonatomic, assign) CGFloat content_height;
@end

NS_ASSUME_NONNULL_END
