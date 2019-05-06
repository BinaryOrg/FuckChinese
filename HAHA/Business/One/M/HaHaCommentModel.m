//
//  HaHaCommentModel.m
//  HAHA
//
//  Created by Maker on 2019/3/30.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import "HaHaCommentModel.h"

@implementation HaHaCommentModel
- (void)setContent:(NSString *)content {
    _content = content;
    self.content_height = [content heightWithLabelFont:[UIFont systemFontOfSize:14] withLabelWidth:SCREENWIDTH - 100];
}

@end
