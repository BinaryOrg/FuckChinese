//
//  YMHLSubCommentsModel.h
//  HAHA
//
//  Created by ZDD on 2019/3/31.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "YMHLUserModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 "id": "subcomment-8f611de0-523d-11e9-8369-13fb2539f43a",
 "content": "啧啧啧, 我卖酱油",
 "create_date": 1553875996,
 "parent_id": "comment-0a51a8f0-523c-11e9-93b2-01bc74441cd7",
 "src_user": {
 "mobile_number": "18345157194",
 "user_name": "CaryCCCCCCCCCCCC",
 "user_id": "user-95f223a0-505f-11e9-838a-a98a5f69dc3d",
 "gender": "f",
 "avatar": "user/user-95f223a0-505f-11e9-838a-a98a5f69dc3d/upload_863d6c87762667d2323566f2aaa11676.jpg",
 "create_date": 1553670707,
 "last_login_date": 1553870826
 },
 "tar_user": {
 "mobile_number": "18345157194",
 "user_name": "CaryCCCCCCCCCCCC",
 "user_id": "user-95f223a0-505f-11e9-838a-a98a5f69dc3d",
 "gender": "f",
 "avatar": "user/user-95f223a0-505f-11e9-838a-a98a5f69dc3d/upload_863d6c87762667d2323566f2aaa11676.jpg",
 "create_date": 1553670707,
 "last_login_date": 1553870826
 }
 */
@interface YMHLSubCommentsModel : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger create_date;
@property (nonatomic, strong) YMHLUserModel *src_user;
@property (nonatomic, strong) YMHLUserModel *tar_user;
@property (nonatomic, assign) CGFloat content_height;
@end

NS_ASSUME_NONNULL_END
