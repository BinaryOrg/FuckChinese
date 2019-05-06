//
//  HaHaCommentModel.h
//  HAHA
//
//  Created by Maker on 2019/3/30.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface HaHaCommentModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *target_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger create_date;
@property (nonatomic, strong) GODUserModel *user;

@property (nonatomic, assign) CGFloat content_height;
@property (nonatomic, assign) BOOL is_star;
@end

NS_ASSUME_NONNULL_END
