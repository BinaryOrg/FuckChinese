//
//  YMHLUserModel.h
//  HAHA
//
//  Created by ZDD on 2019/3/30.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN
/*
 "mobile_number": "12345678901",
 "user_name": "Admin",
 "user_id": "user-super-admin",
 "gender": "f",
 "avatar": "user/user-super-admin/timg3.jpg",
 "create_date": 1553670707,
 "last_login_date": 1553870826
 */
@interface YMHLUserModel : NSObject
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *create_date;

@end

NS_ASSUME_NONNULL_END
