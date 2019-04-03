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

- (instancetype)initWithModel:(ZDDCommentModel *)model {
    if (self = [super init]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addBgvNode];
        [self addNameNode];
        [self addContentNode];
        [self addTimeNode];
        [self addIconNode];
        
        self.iconNode.defaultImage = [UIImage imageNamed:@"bg"];
        self.iconNode.URL = [NSURL URLWithString:model.user.avatar];
        
        self.nameNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:model.user.user_name attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Medium" size:13]).lh_color([UIColor blackColor]);
        }];
        
        self.contentNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:model.content attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:16]).lh_color(color(53, 64, 72, 1));
        }];
        
        self.timeNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:[self formatFromTS:model.create_date] attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Regular" size:12]).lh_color(color(137, 137, 137, 1));
        }];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *iconAdnNameSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    iconAdnNameSpec.spacing = 15;
    iconAdnNameSpec.alignItems = ASStackLayoutAlignItemsCenter;
    iconAdnNameSpec.children = @[self.iconNode, self.nameNode];
    
    ASStackLayoutSpec *contentSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    contentSpec.spacing = 15;
    contentSpec.children = @[iconAdnNameSpec, self.contentNode];
    
    ASStackLayoutSpec *timeSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    timeSpec.spacing = 20;
    timeSpec.children = @[contentSpec, self.timeNode];
    
    ASInsetLayoutSpec *bgvSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(self.bgvEdge.top != 0)?self.bgvEdge:UIEdgeInsetsMake(-20, -20, -20, -20) child:self.bgvNode];
    ASOverlayLayoutSpec *overLay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:timeSpec overlay:bgvSpec];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(30, 20, 40, 20) child:overLay];
}

- (void)setBgvEdge:(UIEdgeInsets)bgvEdge {
    _bgvEdge = bgvEdge;
}


- (NSString *)formatFromTS:(NSInteger)ts {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *str = [NSString stringWithFormat:@"%@",
                     [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ts]]];
    return str;
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
