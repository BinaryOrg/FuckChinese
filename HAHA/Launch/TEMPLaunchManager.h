//
//  TEMPLaunchManager.h
//  Template
//
//  Created by 张冬冬 on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TEMPLaunchManager : NSObject
+ (instancetype)defaultManager;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)launchInWindow:(UIWindow *)window;
@end

NS_ASSUME_NONNULL_END
