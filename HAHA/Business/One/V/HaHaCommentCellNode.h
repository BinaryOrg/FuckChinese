//
//  HaHaCommentCellNode.h
//  HAHA
//
//  Created by Maker on 2019/3/30.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import "HaHaCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HaHaCommentCellNode : ASCellNode

- (instancetype)initWithModel:(HaHaCommentModel *)model;

@property (nonatomic, assign) UIEdgeInsets bgvEdge;

@end

NS_ASSUME_NONNULL_END
