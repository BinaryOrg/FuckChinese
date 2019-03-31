//
//  ZDDCommentModel.m
//  HAHA
//
//  Created by Maker on 2019/3/30.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "ZDDCommentModel.h"

@implementation ZDDCommentModel
- (void)setContent:(NSString *)content {
    _content = content;
    self.content_height = [content heightWithLabelFont:[UIFont systemFontOfSize:14] withLabelWidth:SCREENWIDTH - 100];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"subcomments" : [YMHLSubCommentsModel class]};
}
@end
