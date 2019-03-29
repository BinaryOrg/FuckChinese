//
//  ZDDPhotoBrowseView.m
//  KDCP
//
//  Created by Maker on 2019/3/6.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDPhotoBrowseView.h"
#import <AssetsLibrary/AssetsLibrary.h>
//#import <FLAnimatedImageView+WebCache.h>
#import <YYCategories.h>
#import <UIImageView+WebCache.h>

#import "UIView+LH.h"

#define kPadding 20
#define kHiColor [UIColor colorWithRGBHex:0x2dd6b8]
#define SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })
#define iOS9_Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

@interface LHPhotoGroupItem()<NSCopying>
@property (nonatomic, readonly) UIImage *thumbImage;
/// 保存的图片
@property (nonatomic, strong) UIImage *photo;
/// 图片数据
@property (nonatomic, strong) NSData *photoData;
@property (nonatomic, readonly) BOOL thumbClippedToTop;
- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view;
@end
@implementation LHPhotoGroupItem

- (UIImage *)thumbImage {
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    } else if (_thumbView.extra) {
        return _thumbView.extra;
    }
    return nil;
}

- (void)setThumbView:(UIView *)thumbView {
    _thumbView = thumbView;
    _thumbView.contentMode = UIViewContentModeScaleAspectFill;
}

- (BOOL)thumbClippedToTop {
    if (_thumbView) {
        if (_thumbView.layer.contentsRect.size.height < 1) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view {
    if (imageSize.width < 1 || imageSize.height < 1) return NO;
    if (view.width < 1 || view.height < 1) return NO;
    return imageSize.height / imageSize.width > view.width / view.height;
}

- (id)copyWithZone:(NSZone *)zone {
    LHPhotoGroupItem *item = [self.class new];
    return item;
}
@end



@interface YYPhotoGroupCell : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) LHPhotoGroupItem *item;
@property (nonatomic, readonly) BOOL itemDidLoad;

@property (nonatomic, copy) void (^progreeeBlock)(CGFloat progress, YYPhotoGroupCell *cell);


- (void)resizeSubviewSize;
@end

@implementation YYPhotoGroupCell

- (instancetype)init {
    self = super.init;
    if (!self) return nil;
    self.delegate = self;
    self.bouncesZoom = YES;
    self.maximumZoomScale = 3;
    self.multipleTouchEnabled = YES;
    self.alwaysBounceVertical = NO;
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.frame = [UIScreen mainScreen].bounds;
    
    _imageContainerView = [UIView new];
    _imageContainerView.clipsToBounds = YES;
    [self addSubview:_imageContainerView];
    
    _imageView = [YYAnimatedImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    [_imageContainerView addSubview:_imageView];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.size = CGSizeMake(40, 40);
    _progressLayer.cornerRadius = 20;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = 4;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [self.layer addSublayer:_progressLayer];
    
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _progressLayer.center = CGPointMake(self.width / 2, self.height / 2);
}

- (void)setItem:(LHPhotoGroupItem *)item {
    if (_item == item){
        return;
    }
    _item = item;
    _itemDidLoad = NO;
    
    
    [self setZoomScale:1.0 animated:NO];
    self.maximumZoomScale = 1;
    
    [_imageView sd_cancelCurrentAnimationImagesLoad];
    [_imageView.layer removePreviousFadeAnimation];
    
    _progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (!_item) {
        _imageView.image = nil;
        return;
    }
    _imageView.image = item.thumbImage;
    [self loadImage];
    
    
    [self resizeSubviewSize];
}

- (void)loadImage {
    
    UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:self.item.largeImageURL.absoluteString];
    NSString *imgUrl = self.item.largeImageURL.absoluteString;

    if (self.progreeeBlock && self.item.showLageImage) {
        self.progreeeBlock(0.0f, self);
    }
    __weak typeof(self)weakSelf = self;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        __strong typeof(weakSelf)self = weakSelf;
        if (!self) return;
        CGFloat progress = receivedSize / (float)expectedSize;
        progress = progress < 0.01f ? 0.01f : progress >= 1.0f ? .99f : progress;
        if (isnan(progress)) progress = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressLayer.hidden = NO;
            self.progressLayer.strokeEnd = progress;
            self.scrollEnabled = NO;
            SAFE_BLOCK(self.progreeeBlock, progress, self);
        });
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!image || !strongSelf) {
                SAFE_BLOCK(strongSelf.progreeeBlock, 1.0f, self);
                return;
            }
            strongSelf.item.photo = image;
            self.scrollEnabled = YES;
            strongSelf.progressLayer.hidden = YES;
            strongSelf.maximumZoomScale = 3;
            strongSelf->_itemDidLoad = YES;
            [strongSelf resizeSubviewSize];
            [strongSelf.imageView.layer addFadeAnimationWithDuration:0.1 curve:UIViewAnimationCurveLinear];
            if ([imageURL.pathExtension caseInsensitiveCompare:@"gif"] != NSOrderedSame) {
                strongSelf.imageView.image = image;
                SAFE_BLOCK(strongSelf.progreeeBlock, 1.0f, self);
                return;
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                /// 加载GIF
                NSData *newData = data;
                if (!newData) {
                    NSString *path = [[SDImageCache sharedImageCache] defaultCachePathForKey:imageURL.absoluteString];
                    newData = [NSData dataWithContentsOfFile:path];
                }
                strongSelf.imageView.image = [UIImage imageWithData:newData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.item.photoData = newData;
                    SAFE_BLOCK(strongSelf.progreeeBlock, 1.0f, self);
                });
            });
        });
    }];
}

- (void)resizeSubviewSize {
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    self.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [self scrollRectToVisible:self.bounds animated:NO];
    
    if (_imageContainerView.height <= self.height) {
        self.alwaysBounceVertical = NO;
    } else {
        self.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageContainerView.bounds;
    [CATransaction commit];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end












@interface ZDDPhotoBrowseView() <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toContainerView;

@property (nonatomic, strong) UIImage *snapshotImage;
@property (nonatomic, strong) UIImage *snapshorImageHideFromView;

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *blurBackground;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) UIPageControl *pager;
@property (nonatomic, assign) CGFloat pagerCurrentPage;
@property (nonatomic, assign) BOOL fromNavigationBarHidden;

@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint panGestureBeginPoint;
@property (nonatomic, assign) BOOL addActionSheet;

@property (nonatomic, strong) UIButton *downloadButn;
@property (nonatomic, strong) UIButton *showOriginalImageBtn;

@end

@implementation ZDDPhotoBrowseView

- (instancetype)initWithGroupItems:(NSArray *)groupItems {
    self = [super init];
    if (groupItems.count == 0) return nil;
    _groupItems = groupItems.copy;
    _blurEffectBackground = YES;
    
    NSString *model = [UIDevice currentDevice].machineModel;
    static NSMutableSet *oldDevices;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oldDevices = [NSMutableSet new];
        [oldDevices addObject:@"iPod1,1"];
        [oldDevices addObject:@"iPod2,1"];
        [oldDevices addObject:@"iPod3,1"];
        [oldDevices addObject:@"iPod4,1"];
        [oldDevices addObject:@"iPod5,1"];
        
        [oldDevices addObject:@"iPhone1,1"];
        [oldDevices addObject:@"iPhone1,1"];
        [oldDevices addObject:@"iPhone1,2"];
        [oldDevices addObject:@"iPhone2,1"];
        [oldDevices addObject:@"iPhone3,1"];
        [oldDevices addObject:@"iPhone3,2"];
        [oldDevices addObject:@"iPhone3,3"];
        [oldDevices addObject:@"iPhone4,1"];
        
        [oldDevices addObject:@"iPad1,1"];
        [oldDevices addObject:@"iPad2,1"];
        [oldDevices addObject:@"iPad2,2"];
        [oldDevices addObject:@"iPad2,3"];
        [oldDevices addObject:@"iPad2,4"];
        [oldDevices addObject:@"iPad2,5"];
        [oldDevices addObject:@"iPad2,6"];
        [oldDevices addObject:@"iPad2,7"];
        [oldDevices addObject:@"iPad3,1"];
        [oldDevices addObject:@"iPad3,2"];
        [oldDevices addObject:@"iPad3,3"];
    });
    if ([oldDevices containsObject:model]) {
        _blurEffectBackground = NO;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    self.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [self addGestureRecognizer:tap2];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    press.delegate = self;
    [self addGestureRecognizer:press];
    
    if (kSystemVersion >= 7) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        _panGesture = pan;
    }
    
    _cells = @[].mutableCopy;
    
    _background = UIImageView.new;
    _background.frame = self.bounds;
    _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _blurBackground = UIImageView.new;
    _blurBackground.frame = self.bounds;
    _blurBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _contentView = UIView.new;
    _contentView.frame = self.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _scrollView = UIScrollView.new;
    _scrollView.frame = CGRectMake(-kPadding / 2, 0, self.width + kPadding, self.height);
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = groupItems.count > 1;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    
    _pager = [[UIPageControl alloc] init];
    [_pager setValue:[[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(8, 3)] imageByRoundCornerRadius:4] forKeyPath:@"_currentPageImage"];
    [_pager setValue:[[UIImage imageWithColor:color(255, 255, 255, 0.3) size:CGSizeMake(8, 3)] imageByRoundCornerRadius:4] forKeyPath:@"_pageImage"];
    
    _pager.hidesForSinglePage = YES;
    _pager.userInteractionEnabled = NO;
    _pager.width = self.width - 36;
    _pager.height = 10;
    _pager.center = CGPointMake(self.width / 2, self.height - 20 - SafeAreaBottomHeight);
    _pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    _downloadButn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downloadButn.frame = CGRectMake(CGRectGetMaxX(self.frame) - 55, CGRectGetMaxY(self.frame) - 81 - SafeAreaBottomHeight, 40, 40);
    _downloadButn.layer.cornerRadius = 10;
    _downloadButn.layer.masksToBounds = YES;
    _downloadButn.layer.borderWidth = 1;
    _downloadButn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4].CGColor;
    [_downloadButn setImage:[UIImage imageNamed:@"btn_download_pic"] forState:UIControlStateNormal];
    _downloadButn.adjustsImageWhenHighlighted = NO;
    [_downloadButn addTarget:self action:@selector(savePhotoForUser) forControlEvents:UIControlEventTouchUpInside];
    _downloadButn.backgroundColor = color(0, 0, 0, 0.36);
    
    
    _showOriginalImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showOriginalImageBtn setTitle:@"加载原图" forState:UIControlStateNormal];
    _showOriginalImageBtn.center = CGPointMake(self.width / 2.0 - 60, self.height - 81 - SafeAreaBottomHeight);
    _showOriginalImageBtn.size = CGSizeMake(120, 26);
    _showOriginalImageBtn.layer.cornerRadius = 13;
    _showOriginalImageBtn.layer.masksToBounds = YES;
    _showOriginalImageBtn.layer.borderWidth = 1;
    _showOriginalImageBtn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4].CGColor;
    _showOriginalImageBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_showOriginalImageBtn addTarget:self action:@selector(showOriginalImage) forControlEvents:UIControlEventTouchUpInside];
    _showOriginalImageBtn.alpha = 0.0f;
    _showOriginalImageBtn.adjustsImageWhenHighlighted = NO;
    _showOriginalImageBtn.backgroundColor = color(0, 0, 0, 0.36);
    
    
    [self addSubview:_background];
    [self addSubview:_blurBackground];
    [self addSubview:_contentView];
    [_contentView addSubview:_scrollView];
    [_contentView addSubview:_pager];
    [self addSubview:_downloadButn];
    [self addSubview:_showOriginalImageBtn];
    
    
    return self;
}


- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion {
    if (!toContainer) return;
    _fromView = fromView;
    _toContainerView = toContainer;
    
    NSInteger page = -1;
    for (NSUInteger i = 0; i < self.groupItems.count; i++) {
        if (fromView == ((LHPhotoGroupItem *)self.groupItems[i]).thumbView) {
            page = (int)i;
            break;
        }
    }
    if (page == -1) page = 0;
    if (_fromItemIndex) {
        page = _fromItemIndex;
    } else {
        _fromItemIndex = page;
    }
    
    _snapshotImage = [_toContainerView snapshotImageAfterScreenUpdates:NO];
    BOOL fromViewHidden = fromView.hidden;
    fromView.hidden = YES;
    _snapshorImageHideFromView = [_toContainerView snapshotImage];
    fromView.hidden = fromViewHidden;
    
    _background.image = _snapshorImageHideFromView;
    if (_blurEffectBackground) {
        _blurBackground.image = [_snapshorImageHideFromView imageByBlurDark]; //和毛玻璃一样 UIBlurEffectStyleDark
    } else {
        _blurBackground.image = [UIImage imageWithColor:[UIColor blackColor]];
    }
    
    self.size = _toContainerView.size;
    self.blurBackground.alpha = 0;
    self.pager.alpha = 0;
    self.downloadButn.hidden = YES;
    self.pager.numberOfPages = self.groupItems.count;
    self.pager.currentPage = page;
    [_toContainerView addSubview:self];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * self.groupItems.count, _scrollView.height);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _pager.currentPage, 0, _scrollView.width, _scrollView.height) animated:NO];
    [self scrollViewDidScroll:_scrollView];
    
    [UIView setAnimationsEnabled:YES];
    _fromNavigationBarHidden = [UIApplication sharedApplication].statusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    
    YYPhotoGroupCell *cell = [self cellForPage:self.currentPage];
    LHPhotoGroupItem *item = _groupItems[self.currentPage];
    
    if (!item.thumbClippedToTop) {
        NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:item.largeImageURL];
        if ([[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:imageKey]) {
            cell.item = item;
        }
    }
    if (!cell.item) {
        cell.imageView.image = item.thumbImage;
        [cell resizeSubviewSize];
    }
    
    if (item.thumbClippedToTop) {
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell];
        CGRect originFrame = cell.imageContainerView.frame;
        CGFloat scale = fromFrame.size.width / cell.imageContainerView.width;
        
        cell.imageContainerView.centerX = CGRectGetMidX(fromFrame);
        cell.imageContainerView.height = fromFrame.size.height / scale;
        cell.imageContainerView.layer.transformScale = scale;
        cell.imageContainerView.centerY = CGRectGetMidY(fromFrame);
        
        float oneTime = animated ? 0.25 : 0;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            self->_blurBackground.alpha = 1;
        }completion:NULL];
        
        _scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageContainerView.layer.transformScale = 1;
            cell.imageContainerView.frame = originFrame;
            self->_pager.alpha = 1;
            self->_downloadButn.hidden = NO;
        }completion:^(BOOL finished) {
            self->_isPresented = YES;
            [self scrollViewDidScroll:self->_scrollView];
            self->_scrollView.userInteractionEnabled = YES;
            [self hidePager];
            if (completion) completion();
        }];
        
    } else {
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell.imageContainerView];
        
        cell.imageContainerView.clipsToBounds = NO;
        cell.imageView.frame = fromFrame;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        float oneTime = animated ? 0.18 : 0;
        [UIView animateWithDuration:oneTime*2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            self->_blurBackground.alpha = 1;
        }completion:NULL];
        
        _scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageView.frame = cell.imageContainerView.bounds;
            cell.imageView.layer.transformScale = 1.01;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.imageView.layer.transformScale = 1.0;
                self->_pager.alpha = 1;
                self->_downloadButn.hidden = NO;
            }completion:^(BOOL finished) {
                cell.imageContainerView.clipsToBounds = YES;
                self->_isPresented = YES;
                [self scrollViewDidScroll:self->_scrollView];
                self->_scrollView.userInteractionEnabled = YES;
                [self hidePager];
                if (completion) completion();
            }];
        }];
    }
    
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [UIView setAnimationsEnabled:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:_fromNavigationBarHidden withAnimation:UIStatusBarAnimationNone];
    NSInteger currentPage = self.currentPage;
    YYPhotoGroupCell *cell = [self cellForPage:currentPage];
    LHPhotoGroupItem *item = _groupItems[currentPage];
    
    UIView *fromView = nil;
    if (_fromItemIndex == currentPage
        || self.isBacktrack) {
        fromView = _fromView;
    } else {
        fromView = item.thumbView;
    }
    
    [self cancelAllImageLoad];
    _isPresented = NO;
    BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (isFromImageClipped) {
        CGRect frame = cell.imageContainerView.frame;
        cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0);
        cell.imageContainerView.frame = frame;
    }
    cell.progressLayer.hidden = YES;
    [CATransaction commit];
    
    
    
    
    if (fromView == nil) {
        self.background.image = _snapshotImage;
        [UIView animateWithDuration:animated ? 0.25 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0.0;
            self.scrollView.layer.transformScale = 0.95;
            self.scrollView.alpha = 0;
            self.pager.alpha = 0;
            self.blurBackground.alpha = 0;
        }completion:^(BOOL finished) {
            self.downloadButn.hidden = YES;
            self.scrollView.layer.transformScale = 1;
            [self removeFromSuperview];
            [self cancelAllImageLoad];
            if (completion) completion();
        }];
        return;
    }
    
    if (_fromItemIndex != currentPage) {
        _background.image = _snapshotImage;
        [_background.layer addFadeAnimationWithDuration:0.25 curve:UIViewAnimationCurveEaseOut];
    } else {
        _background.image = _snapshorImageHideFromView;
    }
    
    
    if (isFromImageClipped) {
        [cell scrollToTopAnimated:NO];
    }
    
    [UIView animateWithDuration:animated ? 0.2 : 0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->_pager.alpha = 0.0;
        self->_blurBackground.alpha = 0.0;
        if (isFromImageClipped) {
            
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell];
            CGFloat scale = fromFrame.size.width / cell.imageContainerView.width * cell.zoomScale;
            CGFloat height = fromFrame.size.height / fromFrame.size.width * cell.imageContainerView.width;
            if (isnan(height)) height = cell.imageContainerView.height;
            
            cell.imageContainerView.height = height;
            cell.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMinY(fromFrame));
            cell.imageContainerView.layer.transformScale = scale;
            
        } else {
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell.imageContainerView];
            cell.imageContainerView.clipsToBounds = NO;
            cell.imageView.frame = fromFrame;
            cell.imageView.contentMode = fromView.contentMode;
            cell.imageView.layer.cornerRadius = fromView.layer.cornerRadius;
            cell.imageView.clipsToBounds = YES;
        }
    }completion:^(BOOL finished) {
        self->_downloadButn.hidden = YES;
        
        [UIView animateWithDuration:animated ? 0.15 : 0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            [self removeFromSuperview];
            if (completion) completion();
        }];
    }];
    
    
}

- (void)dismiss {
    [self dismissAnimated:YES completion:nil];
}


- (void)cancelAllImageLoad {
    [_cells enumerateObjectsUsingBlock:^(YYPhotoGroupCell *cell, NSUInteger idx, BOOL *stop) {
        [cell.imageView sd_cancelCurrentAnimationImagesLoad];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCellsForReuse];
    
    CGFloat floatPage = _scrollView.contentOffset.x / _scrollView.width;
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    
    for (NSInteger i = page - 1; i <= page + 1; i++) { // preload left and right cell
        if (i >= 0 && i < self.groupItems.count) {
            YYPhotoGroupCell *cell = [self cellForPage:i];
            if (!cell) {
                YYPhotoGroupCell *cell = [self dequeueReusableCell];
                cell.page = i;
                cell.left = (self.width + kPadding) * i + kPadding / 2;
                
                if (_isPresented) {
                    cell.item = self.groupItems[i];
                }
                [self.scrollView addSubview:cell];
            } else {
                if (_isPresented && !cell.item) {
                    cell.item = self.groupItems[i];
                }
            }
        }
    }
    
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _groupItems.count ? (int)_groupItems.count - 1 : intPage;
    _pager.currentPage = intPage;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self->_pager.alpha = 1;
        self->_downloadButn.hidden = NO;
    }completion:^(BOOL finish) {
    }];
    [self hideOrShowShowOriginalImageBtn];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self hidePager];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self hidePager];
    [self hideOrShowShowOriginalImageBtn];
}


- (void)showOriginalImage {
    
    YYPhotoGroupCell *cell = [self cellForPage:self.currentPage];
    cell.item.showLageImage = YES;
    [cell loadImage];
    
}

- (void)hideOrShowShowOriginalImageBtn {
    
    YYPhotoGroupCell *currentCell = [self cellForPage:self.currentPage];
    
    UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:currentCell.item.largeImageURL.absoluteString];
    
    CGFloat size = currentCell.item.size/1024.0/1024.0;
    if (size >= 2
        && ([currentCell.item.largeImageURL.absoluteString.pathExtension caseInsensitiveCompare:@"gif"]!= NSOrderedSame) && !image) {
        [self.showOriginalImageBtn setTitle:[NSString stringWithFormat:@"查看原图(%.1fM)", size] forState:UIControlStateNormal];
        self.showOriginalImageBtn.alpha = 1.0f;
    }else {
        self.showOriginalImageBtn.alpha = 0.0f;
    }
    __weak typeof(self)weakSelf = self;
    __weak typeof(currentCell)weakCell = currentCell;
    currentCell.progreeeBlock = ^(CGFloat progress, YYPhotoGroupCell *cell) {
        if (cell.page != weakSelf.currentPage) {
            return ;
        }
        if (weakCell.item.showLageImage) {
            if (progress < 1.0f) {
                [weakSelf.showOriginalImageBtn setTitle:[NSString stringWithFormat:@"正在下载 %.0f%%", progress * 100] forState:UIControlStateNormal];
            }else {
                [weakSelf.showOriginalImageBtn setTitle:@"已完成" forState:UIControlStateNormal];
                weakSelf.showOriginalImageBtn.alpha = 0.0f;
                
            }
        }
    };
    
}

- (void)hidePager {
    [UIView animateWithDuration:0.3 delay:3.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        self->_pager.alpha = 0;
    }completion:^(BOOL finish) {
        self->_downloadButn.hidden = YES;
    }];
}

/// enqueue invisible cells for reuse
- (void)updateCellsForReuse {
    for (YYPhotoGroupCell *cell in _cells) {
        if (cell.superview) {
            if (cell.left > _scrollView.contentOffset.x + _scrollView.width * 2||
                cell.right < _scrollView.contentOffset.x - _scrollView.width) {
                [cell removeFromSuperview];
                cell.page = -1;
                cell.item = nil;
            }
        }
    }
}

/// dequeue a reusable cell
- (YYPhotoGroupCell *)dequeueReusableCell {
    YYPhotoGroupCell *cell = nil;
    for (cell in _cells) {
        if (!cell.superview) {
            return cell;
        }
    }
    
    cell = [YYPhotoGroupCell new];
    cell.frame = self.bounds;
    cell.imageContainerView.frame = self.bounds;
    cell.imageView.frame = cell.bounds;
    cell.page = -1;
    cell.item = nil;
    [_cells addObject:cell];
    return cell;
}

/// get the cell for specified page, nil if the cell is invisible
- (YYPhotoGroupCell *)cellForPage:(NSInteger)page {
    for (YYPhotoGroupCell *cell in _cells) {
        if (cell.page == page) {
            return cell;
        }
    }
    return nil;
}

- (NSInteger)currentPage {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    if (page >= _groupItems.count) page = (NSInteger)_groupItems.count - 1;
    if (page < 0) page = 0;
    return page;
}

- (void)showHUD:(NSString *)msg {
    if (!msg.length) return;
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize size = [msg sizeForFont:font size:CGSizeMake(200, 200) mode:NSLineBreakByCharWrapping];
    UILabel *label = [UILabel new];
    label.size = CGSizePixelCeil(size);
    label.font = font;
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    
    UIView *hud = [UIView new];
    hud.size = CGSizeMake(label.width + 20, label.height + 20);
    hud.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.650];
    hud.clipsToBounds = YES;
    hud.layer.cornerRadius = 8;
    
    label.center = CGPointMake(hud.width / 2, hud.height / 2);
    [hud addSubview:label];
    
    hud.center = CGPointMake(self.width / 2, self.height / 2);
    hud.alpha = 0;
    [self addSubview:hud];
    
    [UIView animateWithDuration:0.4 animations:^{
        hud.alpha = 1;
    }];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.4 animations:^{
            hud.alpha = 0;
        } completion:^(BOOL finished) {
            [hud removeFromSuperview];
        }];
    });
}

- (void)doubleTap:(UITapGestureRecognizer *)g {
    if (!_isPresented) return;
    YYPhotoGroupCell *tile = [self cellForPage:self.currentPage];
    if (tile) {
        if (tile.zoomScale > 1) {
            [tile setZoomScale:1 animated:YES];
        } else {
            CGPoint touchPoint = [g locationInView:tile.imageView];
            CGFloat newZoomScale = tile.maximumZoomScale;
            CGFloat xsize = self.width / newZoomScale;
            CGFloat ysize = self.height / newZoomScale;
            [tile zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}

- (void)longPress {
    if (!_isPresented) return;
    
    YYPhotoGroupCell *tile = [self cellForPage:self.currentPage];
    if (!tile.imageView.image) return;
    
    // try to save original image data if the image contains multi-frame (such as GIF/APNG)
    //    id imageItem = [tile.imageView.image yy_imageDataRepresentation];
    //    YYImageType type = YYImageDetectType((__bridge CFDataRef)(imageItem));
    //    if (type != YYImageTypePNG &&
    //        type != YYImageTypeJPEG &&
    //        type != YYImageTypeGIF) {
    //        imageItem = tile.imageView.image;
    //    }
    if(!_addActionSheet)
    {
//        ZDDSheetView *sheetView = [[ZDDSheetView alloc] initWithTitle:nil style:nil itemTitles:@[@"保存图片"]];
//        sheetView.block = ^(NSInteger index, NSString *title, ZDDSheetView *sender) {
//            if (index == 0) {
//                [self savePhotoForUser];
//            }
//        };
//        [sheetView showAlert];
//
//        _addActionSheet = YES;
    }
    //    UIActivityViewController *activityViewController =
    //    [[UIActivityViewController alloc] initWithActivityItems:@[imageItem] applicationActivities:nil];
    //    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
    //        activityViewController.popoverPresentationController.sourceView = self;
    //    }
    //
    //    UIViewController *toVC = self.toContainerView.viewController;
    //    if (!toVC) toVC = self.viewController;
    //    [toVC presentViewController:activityViewController animated:YES completion:nil];
}

- (void)pan:(UIPanGestureRecognizer *)g {
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isPresented) {
                _panGestureBeginPoint = [g locationInView:self];
            } else {
                _panGestureBeginPoint = CGPointZero;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            _scrollView.top = deltaY;
            
            CGFloat alphaDelta = 160;
            CGFloat alpha = (alphaDelta - fabs(deltaY) + 50) / alphaDelta;
            alpha = YY_CLAMP(alpha, 0, 1);
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                self->_blurBackground.alpha = alpha;
                self->_pager.alpha = alpha;
            } completion:^(BOOL finished) {
                if (alpha < 1) {
                    self->_downloadButn.hidden = YES;
                }else {
                    self->_downloadButn.hidden = NO;
                }
            }];
            
        } break;
        case UIGestureRecognizerStateEnded: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint v = [g velocityInView:self];
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120) {
                [self cancelAllImageLoad];
                _isPresented = NO;
                [[UIApplication sharedApplication] setStatusBarHidden:_fromNavigationBarHidden withAnimation:UIStatusBarAnimationFade];
                
                BOOL moveToTop = (v.y < - 50 || (v.y < 50 && deltaY < 0));
                CGFloat vy = fabs(v.y);
                if (vy < 1) vy = 1;
                CGFloat duration = (moveToTop ? _scrollView.bottom : self.height - _scrollView.top) / vy;
                duration *= 0.8;
                duration = YY_CLAMP(duration, 0.05, 0.3);
                
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    self->_blurBackground.alpha = 0;
                    self->_pager.alpha = 0;
                    
                    if (moveToTop) {
                        self->_scrollView.bottom = 0;
                    } else {
                        self->_scrollView.top = self.height;
                    }
                } completion:^(BOOL finished) {
                    self->_downloadButn.hidden = YES;
                    [self removeFromSuperview];
                }];
                
                _background.image = _snapshotImage;
                [_background.layer addFadeAnimationWithDuration:0.3 curve:UIViewAnimationCurveEaseInOut];
                
            } else {
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:v.y / 1000 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    self->_scrollView.top = 0;
                    self->_blurBackground.alpha = 1;
                    self->_pager.alpha = 1;
                    self->_downloadButn.hidden = NO;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        } break;
        case UIGestureRecognizerStateCancelled : {
            _scrollView.top = 0;
            _blurBackground.alpha = 1;
        }
        default:break;
    }
}


- (void)savePhotoForUser {

    LHPhotoGroupItem *item = _groupItems[self.currentPage];
    [self savePhotoToCustomAlbumWithName:@"口味菜谱" photo:item.photo];
}

#pragma mark - 相册操作
- (void)savePhotoToCustomAlbumWithName:(NSString *)albumName photo:(UIImage *)photo{
    if (!photo) {
        return;
    }
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!iOS9_Later) {
                UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
                return;
            }
            NSError *error = nil;
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                if (@available(iOS 9.0, *)) {
                    createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:photo].placeholderForCreatedAsset;
                }
            } error:&error];
            
            if (error) {
                return;
            }
            
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self createCollection:albumName];
            if (collection == nil) {
                return;
            }
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
           
        });
    }];
}

// 创建自己要创建的自定义相册
- (PHAssetCollection * )createCollection:(NSString *)albumName {
    NSString * title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    PHFetchResult<PHAssetCollection *> *collections =  [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHAssetCollection * createCollection = nil;
    for (PHAssetCollection * collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            createCollection = collection;
            break;
        }
    }
    if (createCollection == nil) {
        
        NSError * error1 = nil;
        __block NSString * createCollectionID = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            NSString * title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
            createCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error1];
        
        if (error1) {
            return nil;
        }
        // 创建相册之后我们还要获取此相册  因为我们要往进存储相片
        createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createCollectionID] options:nil].firstObject;
    }
    
    return createCollection;
}
@end
