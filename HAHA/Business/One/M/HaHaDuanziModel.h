//
//  HaHaDuanziModel.h
//  HAHA
//
//  Created by Maker on 2019/3/30.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HaHaDuanziModel : NSObject

//"id": "graph-text-bed75adc-4bba-11e9-8f74-1866da33cc6b",
//"content": "现在的女人都这么硬气吗",
//"picture_path": [
//                 "//pic.qiushibaike.com/system/pictures/12153/121534513/medium/4QSU2ZXHK3WEA8DV.jpg"
//                 ],
//"create_date": 1553160104,
//"star_num": 0,
//"comment_num": 0,
//"is_star": false,
//"user": {
//    "mobile_number": "12345678901",
//    "user_name": "Admin",
//    "user_id": "user-super-admin",
//    "gender": "f",
//    "create_date": 1553670707,
//    "last_login_date": 1553870826
//}

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *picture_path;
@property (nonatomic, assign) NSInteger create_date;
@property (nonatomic, assign) NSInteger comment_num;
@property (nonatomic, assign) NSInteger star_num;
@property (nonatomic, assign) BOOL is_star;
@property (nonatomic, strong) GODUserModel *user;

@end

NS_ASSUME_NONNULL_END
