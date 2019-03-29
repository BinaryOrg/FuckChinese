//
//  YMHLVideoflowLayout.h
//  笑笑
//
//  Created by 张冬冬 on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMHLVideoflowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> delegate;
@property (nonatomic, assign) NSInteger cellCount;//cell的个数
@property (nonatomic, strong) NSMutableArray<NSNumber *> *colArr;//存放列的高度
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSIndexPath *> *attributeDict;//存放cell的位置信息
@property (nonatomic, assign) int colCount;//cell共有几列
@end

NS_ASSUME_NONNULL_END
