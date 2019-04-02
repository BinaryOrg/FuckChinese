//
//  ZDDSecondListCellNode.h
//  HAHA
//
//  Created by Maker on 2019/4/1.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "ZDDDuanziModel.h"

@protocol ZDDSecondListCellNodeDelegate <NSObject>

- (void)clickIconWithModel:(GODUserModel *)model;

@end


NS_ASSUME_NONNULL_BEGIN

@interface ZDDSecondListCellNode : ASCellNode

/** <#class#> */
@property (nonatomic, weak) id<ZDDSecondListCellNodeDelegate> delegate;

- (instancetype)initWithModel:(ZDDDuanziModel *)model;


@end

NS_ASSUME_NONNULL_END
