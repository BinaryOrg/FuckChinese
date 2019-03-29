//
//  UIImage+Blur.h
//  KDCP
//
//  Created by ZDD on 2019/3/10.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Blur)

- (UIImage *)blurredImage;
- (UIImage *)blurredImageWithRadius:(CGFloat)radius;
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end

NS_ASSUME_NONNULL_END
