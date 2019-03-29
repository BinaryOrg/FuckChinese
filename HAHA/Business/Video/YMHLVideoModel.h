//
//  YMHLVideoModel.h
//  笑笑
//
//  Created by 张冬冬 on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMHLVideoModel : NSObject
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, assign) NSInteger collection;
@end

NS_ASSUME_NONNULL_END
