//
//  ZDDPhotoBrowseView.h
//  KDCP
//
//  Created by Maker on 2019/3/6.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LHPhotoGroupItem : NSObject
@property (nonatomic, strong) UIView *thumbView; ///< thumb image, used for animation position calculation
@property (nonatomic, assign) CGSize largeImageSize;
@property (nonatomic, strong) NSURL *largeImageURL;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) BOOL showLageImage;
@end


/// Used to show a group of images.
/// One-shot.
@class LHPhotoGroupItem;
@interface ZDDPhotoBrowseView : UIView
@property (nonatomic, readonly) NSArray<LHPhotoGroupItem *> *groupItems;
@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, strong, readonly) UIPageControl *pager;
@property (nonatomic, assign) BOOL blurEffectBackground; ///< Default is YES
@property (nonatomic, assign) NSInteger fromItemIndex;
@property (nonatomic, assign, getter=isBacktrack) BOOL backtrack;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithGroupItems:(NSArray *)groupItems;

- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)container
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismiss;
@end

