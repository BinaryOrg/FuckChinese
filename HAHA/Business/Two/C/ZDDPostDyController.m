//
//  ZDDPostDyController.m
//  HAHA
//
//  Created by Maker on 2019/4/1.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "ZDDPostDyController.h"
#import "HXPhotoPicker.h"

#define kPhotoViewMargin 12.0f

@interface ZDDPostDyController ()

@property (nonatomic, strong) UILabel *tipsLb;
@property (nonatomic, strong) UITextView *contentTextView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ZDDPostDyController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addPhotoView];
}

- (void)addPhotoView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
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
}


- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
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

@end
