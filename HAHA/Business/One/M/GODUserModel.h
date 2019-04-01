//
//  GODUserModel.h
//  Blogger
//
//  Created by Maker on 2019/1/19.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface GODUserModel : NSObject
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *mobile_number;
@property (nonatomic, assign) NSInteger create_date;
@property (nonatomic, assign) NSInteger last_login_date;



@end

NS_ASSUME_NONNULL_END
