//
//  ZDDCommentCellNode.m
//  HAHA
//
//  Created by Maker on 2019/3/30.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "ZDDCommentCellNode.h"

@interface ZDDCommentCellNode ()

@property (nonatomic, strong) ASTextNode *nameNode;
@property (nonatomic, strong) ASNetworkImageNode *iconNode;
@property (nonatomic, strong) ASTextNode *contentNode;
@property (nonatomic, strong) ASTextNode *timeNode;
@property (nonatomic, strong) ASDisplayNode *bgvNode;

@end

@implementation ZDDCommentCellNode

- (instancetype)init {
    if (self = [super init]) {
        
        [self addBgvNode];
        [self addNameNode];
        [self addContentNode];
        [self addTimeNode];
        [self addIconNode];
        
        self.iconNode.URL = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1553922251198&di=012df18c15fd11e6ee2bc439d5114cd8&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn20111%2F119%2Fw989h730%2F20181206%2F1d03-hprknvt3522463.jpg"];
        
        self.nameNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"Maker" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Medium" size:13]).lh_color([UIColor blackColor]);
        }];
        
        self.contentNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"在作用上，我们可以把 React 元素理解为 DOM 元素，但实际上，React 元素只是 JS 当中普通的对象。React 内部实现了一套叫做 React DOM 的东西，或者我们称之为 Virtual DOM 也就是虚拟 DOM.通过一个树状结构的 JS 对象来模拟 DOM 树" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:16]).lh_color(color(53, 64, 72, 1));
        }];
        
        self.timeNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"2019/03/30" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Regular" size:12]).lh_color(color(137, 137, 137, 1));
        }];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *iconAdnNameSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    iconAdnNameSpec.spacing = 15;
    iconAdnNameSpec.children = @[self.iconNode, self.nameNode];
    
    ASStackLayoutSpec *contentSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    contentSpec.spacing = 15;
    contentSpec.children = @[iconAdnNameSpec, self.contentNode];
    
    ASStackLayoutSpec *timeSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    timeSpec.spacing = 20;
    timeSpec.children = @[contentSpec, self.timeNode];
    
    ASInsetLayoutSpec *bgvSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(-20, -20, -20, -20) child:self.bgvNode];
    ASOverlayLayoutSpec *overLay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:timeSpec overlay:bgvSpec];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(30, 20, 40, 20) child:overLay];
}


- (void)addNameNode {
    self.nameNode = [ASTextNode new];
    [self addSubnode:self.nameNode];
}

- (void)addContentNode {
    self.contentNode = [ASTextNode new];
    self.contentNode.style.maxWidth = ASDimensionMake(ScreenWidth - 80);
    [self addSubnode:self.contentNode];
}

- (void)addTimeNode {
    self.timeNode = [ASTextNode new];
    [self addSubnode:self.timeNode];
}

- (void)addIconNode {
    self.iconNode = [ASNetworkImageNode new];
    self.iconNode.style.preferredSize = CGSizeMake(25, 25);
    self.iconNode.cornerRadius = 12.5;
    [self addSubnode:self.iconNode];
}

- (void)addBgvNode {
    self.bgvNode = [ASDisplayNode new];
    self.bgvNode.backgroundColor = [UIColor whiteColor];
    self.bgvNode.cornerRadius = 6;
    [self addSubnode:self.bgvNode];
}
@end
