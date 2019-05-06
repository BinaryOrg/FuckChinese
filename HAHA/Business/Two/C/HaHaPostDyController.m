//
//  HaHaPostDyController.m
//  HAHA
//
//  Created by Maker on 2019/4/1.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import "HaHaPostDyController.h"
#import "HXPhotoPicker.h"

#define kPhotoViewMargin 12.0f

@interface HaHaPostDyController ()

@property (nonatomic, strong) UILabel *tipsLb;
@property (nonatomic, strong) UITextView *contentTextView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation HaHaPostDyController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addPhotoView];
}

- (void)addPhotoView {
    
    self.contentTextView = [[UITextView alloc] init];
    self.contentTextView.font = [UIFont systemFontOfSize:18];
    self.contentTextView.frame = CGRectMake(kPhotoViewMargin, 20, ScreenWidth - kPhotoViewMargin * 2, 150);
    self.contentTextView.text = @"这是一条很有意思的动态~";
    
    [self.view addSubview:self.contentTextView];
    
    self.title = @"发布动态";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, ScreenWidth, ScreenHeight - 200)];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

    CGFloat width = scrollView.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, kPhotoViewMargin, width - kPhotoViewMargin * 2, 0);
    photoView.outerCamera = YES;
    photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
    photoView.previewShowDeleteButton = YES;
    photoView.showAddCell = YES;
    [photoView.collectionView reloadData];
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    
    [self.view addSubview:self.tipsLb];
    [self.tipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(20);
         make.bottom.mas_equalTo(-SafeAreaBottomHeight - 30);
     }];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [nextButton setTitleColor:[UIColor qmui_colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [nextButton setTitle:@"发布" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(clickPostDyBtn) forControlEvents:UIControlEventTouchUpInside];
    [nextButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    
    [self.contentTextView becomeFirstResponder];
}
    
- (void)clickPostDyBtn {
    
    [MFHUDManager showLoading:@"发布..."];
    __weak typeof(self)weakSelf = self;
    NSMutableArray *tempArr = [NSMutableArray array];
    [self.manager.afterSelectedArray enumerateObjectsUsingBlock:^(HXPhotoModel *selectedModel, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (selectedModel.asset) {
            PHImageRequestOptions*options = [[PHImageRequestOptions alloc]init];
            options.deliveryMode=PHImageRequestOptionsDeliveryModeHighQualityFormat;
            [[PHImageManager defaultManager] requestImageDataForAsset:selectedModel.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (imageData) {
                        [tempArr addObject:[UIImage imageWithData:imageData]];
                        if (tempArr.count == strongSelf.manager.afterSelectedArray.count) {
                            [strongSelf postWithImages:tempArr];
                        }
                    }
                });
            }];
        }else {
            if (selectedModel.previewPhoto) {
                [tempArr addObject:selectedModel.previewPhoto];
            }else {
                [tempArr addObject:selectedModel.thumbPhoto];
            }
            if (tempArr.count == self.manager.afterSelectedArray.count) {
                [strongSelf postWithImages:tempArr];
            }
        }
    }];
    
    
    
}

- (void)postWithImages:(NSArray *)images {
    [MFNETWROK upload:@"Duanzi/CreateGT"
               params:@{
                        @"userId": [GODUserTool shared].user.user_id,
                        @"content": self.contentTextView.text,
                        }
                 name:@"pictures"
               images:images
           imageScale:0.1
            imageType:MFImageTypePNG
             progress:nil
              success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                  NSLog(@"%@", result);
                  if ([result[@"resultCode"] isEqualToString:@"0"]) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [MFHUDManager dismiss];
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldReloadDy" object:nil];
                      });
                      [self.navigationController popViewControllerAnimated:YES];
                  }else {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [MFHUDManager showError:@"发布失败！"];
                      });
                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                          [MFHUDManager dismiss];
                      });
                  }
              }
              failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                  NSLog(@"%@", error.userInfo);
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [MFHUDManager showError:@"发布失败！"];
                  });
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [MFHUDManager dismiss];
                  });
              }];
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = NO;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.maxNum = 9;
        _manager.configuration.videoMaximumSelectDuration = 15;
        _manager.configuration.videoMinimumSelectDuration = 0;
        _manager.configuration.videoMaximumDuration = 15.f;
        _manager.configuration.creationDateSort = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.showOriginalBytes = YES;
        _manager.configuration.selectTogether = NO;

    }
    return _manager;
}

- (UILabel *)tipsLb {
    if (!_tipsLb) {
        _tipsLb = [[UILabel alloc] init];
        _tipsLb.font = [UIFont systemFontOfSize:15];
        _tipsLb.textColor = GODColor(137, 137, 137);
        _tipsLb.text = @"有趣的动态展示有趣的你~";
    }
    return _tipsLb;
}
@end
