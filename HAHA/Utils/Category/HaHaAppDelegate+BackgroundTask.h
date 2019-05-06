//
//  AppDelegate+BackgroundTask.h
//

/*
 * 应用进入后台仍可以启动一些后台任务, 如: 短信倒计时 etc.
 */
#import "HaHaAppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface HaHaAppDelegate (BackgroundTask)
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdenifier;
@end

NS_ASSUME_NONNULL_END
