//
//  YMHLVideoModel.h
//  笑笑
//
//  Created by 张冬冬 on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "YMHLUserModel.h"
/*
 {
 "id": "video-text-c0efaee4-4c61-11e9-abdf-cf1d21e5d73c",
 "content": "小明考试就得五分,给老妈鼻子都气歪了,但是我终于知道原因了!",
 "picture_path": "http://mpic.spriteapp.cn/crop/566x360/picture/2019/0320/aef910524b0f11e990a7842b2b4c75ab_wpd.jpg",
 "video": "http://mvideo.spriteapp.cn/video/2019/0320/aef910524b0f11e990a7842b2b4c75ab_wpcco.mp4",
 "create_date": 1553231834,
 "star_num": 0,
 "comment_num": 0,
 "is_star": false,
 "user": {
 
 }
 }
 */
NS_ASSUME_NONNULL_BEGIN

@interface YMHLVideoModel : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *picture_path;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *video;
@property (nonatomic, strong) YMHLUserModel *user;

@property (nonatomic, assign) NSInteger star_num;
@property (nonatomic, assign) NSInteger comment_num;
@property (nonatomic, assign) BOOL is_star;

@end

NS_ASSUME_NONNULL_END
