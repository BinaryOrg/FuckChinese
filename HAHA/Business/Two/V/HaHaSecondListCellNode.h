//
//  HaHaSecondListCellNode.h
//  HAHA
//
//  Created by Maker on 2019/4/1.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import "HaHaDuanziModel.h"

@protocol HaHaSecondListCellNodeDelegate <NSObject>

- (void)clickIconWithModel:(GODUserModel *)model;

@end


NS_ASSUME_NONNULL_BEGIN

@interface HaHaSecondListCellNode : ASCellNode

/** <#class#> */
@property (nonatomic, weak) id<HaHaSecondListCellNodeDelegate> delegate;

- (instancetype)initWithModel:(HaHaDuanziModel *)model;


@end

NS_ASSUME_NONNULL_END
