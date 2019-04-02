//
//  ZDDCommentCellNode.h
//  HAHA
//
//  Created by Maker on 2019/3/30.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "ZDDCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDDCommentCellNode : ASCellNode

- (instancetype)initWithModel:(ZDDCommentModel *)model;

@property (nonatomic, assign) UIEdgeInsets bgvEdge;

@end

NS_ASSUME_NONNULL_END
