//
//  ZDDFistLIstCellNode.m
//  笑笑
//
//  Created by Maker on 2019/3/28.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "ZDDFistListCellNode.h"
#import <YYCGUtilities.h>

@interface ZDDFistListCellNode ()

@property (nonatomic, strong) ASDisplayNode *lineNode;
@property (nonatomic, strong) ASImageNode *commentImgNode;
@property (nonatomic, strong) ASTextNode *commentCountNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASLayoutSpec *picturesLayout;

@property (nonatomic, strong) NSMutableArray *picturesNodes;

@end

@implementation ZDDFistListCellNode

- (instancetype)init {
    if (self = [super init]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addBackgroundNode];
        [self addCommentCountNode];
        [self addCommentImgNode];
        [self addTitleNode];
        
        
        self.titleNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"又被老妈唠叨我除了玩手机啥都不会干，，老妈唠叨够了转过头去看旁边偷笑的小侄女：“妞妞，你长大后可不能像你姑姑这样懒的讨人嫌。” 小侄女想都没想就说：“我真羡慕姑姑，跟猪似的，没心没肺活着不累。。 尼玛。。" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:16]).lh_color(color(53, 64, 72, 1));
        }];
        
        self.commentCountNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"1314520" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:12]).lh_color(color(53, 64, 72, 1));
        }];
        
    }
    return self;
}


//点击图片
- (void)onTouchPictureNode:(ASNetworkImageNode *)imgNode {
    
    
    
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *titleAndImgSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    if (self.picturesNodes.count) {
        titleAndImgSpec.spacing = 15;
        titleAndImgSpec.children = @[self.titleNode, self.picturesLayout];
    }
    
    ASStackLayoutSpec *commentSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    commentSpec.spacing = 6;
    commentSpec.alignItems = ASStackLayoutAlignItemsCenter;
    commentSpec.children = @[self.commentImgNode, self.commentCountNode];
    
    
    ASStackLayoutSpec *titleAndCommentSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    titleAndCommentSpec.spacing = 20;
    if (self.picturesNodes.count) {
        titleAndCommentSpec.children = @[titleAndImgSpec, commentSpec];
    }else {
        titleAndCommentSpec.children = @[self.titleNode, commentSpec];
    }
    
    ASStackLayoutSpec *lineSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    lineSpec.spacing = 15;
    lineSpec.children = @[titleAndCommentSpec, self.lineNode];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(20, 20, 0, 20) child:lineSpec];
    
}


- (void)addCommentCountNode {
    self.commentCountNode = [ASTextNode new];
    [self addSubnode:self.commentCountNode];
}

- (void)addCommentImgNode {
    self.commentImgNode = [ASImageNode new];
    self.commentImgNode.image = [UIImage imageNamed:@"write"];
    self.commentImgNode.style.preferredSize = CGSizeMake(15, 15);
    self.commentCountNode.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubnode:self.commentImgNode];
}

- (void)addBackgroundNode {
    self.lineNode = [ASDisplayNode new];
    self.lineNode.layerBacked = YES;
    self.lineNode.backgroundColor = [UIColor qmui_colorWithHexString:@"EDEDED"];
    self.lineNode.style.preferredSize = CGSizeMake(ScreenWidth - 40.0, 1.0f);
    [self addSubnode:self.lineNode];
}

- (void)addTitleNode {
    self.titleNode = [ASTextNode new];
    self.titleNode.style.maxWidth = ASDimensionMake(SCREENWIDTH - 60);
    [self addSubnode:self.titleNode];
}

- (void)addPicturesNodesWithFiles:(NSArray <ZDDFileModel *>*)files size:(CGSize)size {
    CGSize itemSize = [self pictureSizeWithCount:files.count imageSize:size];
    
    [files enumerateObjectsUsingBlock:^(ZDDFileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ASNetworkImageNode *pictureNode = [ASNetworkImageNode new];
        pictureNode.style.preferredSize = itemSize;
        pictureNode.contentMode = UIViewContentModeScaleAspectFit;
        pictureNode.backgroundColor = [UIColor qmui_colorWithHexString:@"F8F8F8"];
        pictureNode.defaultImage = [self placeholderImage];
        pictureNode.URL = [NSURL URLWithString:obj.fileUrl];
        [pictureNode addTarget:self action:@selector(onTouchPictureNode:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:pictureNode];
        [self.picturesNodes addObject:pictureNode];
    }];
}

- (CGSize)pictureSizeWithCount:(NSInteger)count imageSize:(CGSize)imageSize {
    CGSize itemSize = CGSizeZero;
    CGFloat len1_3 = (ScreenWidth - 50.0f) / 3;
    len1_3 = CGFloatPixelRound(len1_3);
    switch (count) {
            case 1: {
                CGFloat imageW = imageSize.width;
                CGFloat imageH = imageSize.height;
                CGFloat maxWH = (ScreenWidth - 96.0f) / 3 * 2;
                CGFloat minWH = AUTO_FIT(130.0f);
                if (imageW == imageH) {
                    itemSize = CGSizeMake(maxWH, maxWH);
                } else if (imageH > imageW) {
                    itemSize = CGSizeMake(minWH, maxWH);
                } else {
                    itemSize = CGSizeMake(maxWH, minWH);
                }
                break;
            }
            //        case 2:
            //        case 3: {
            //            itemSize = CGSizeMake(len1_3, len1_3);
            //            break;
            //        }
            //        case 4: {
            //            itemSize = CGSizeMake(len1_3, len1_3);
            //            break;
            //        }
            //        case 5:
            //        case 6: {
            //            itemSize = CGSizeMake(len1_3, len1_3);
            //            break;
            //        }
        default: {
            // 7, 8, 9
            itemSize = CGSizeMake(len1_3, len1_3);
            break;
        }
    }
    return itemSize;
}

#pragma mark - Public
- (ASLayoutSpec *)picturesLayout {
    if (_picturesLayout) {
        return _picturesLayout;
    }
    ASLayoutSpec *layout = nil;
    switch (self.picturesNodes.count) {
            case 1:
            case 2:
            case 3: {
                layout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5.0f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:[self.picturesNodes copy]];
                break;
            }
            case 4: {
                NSMutableArray *node1 = [NSMutableArray arrayWithCapacity:2];
                NSMutableArray *node2 = [NSMutableArray arrayWithCapacity:2];
                [self.picturesNodes enumerateObjectsUsingBlock:^(ASNetworkImageNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx < 2) {
                        [node1 addObject:obj];
                        return ;
                    }
                    [node2 addObject:obj];
                }];
                NSMutableArray *tempChildren = @[].mutableCopy;
                [@[node1, node2] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ASStackLayoutSpec *imgSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5.0f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:obj];
                    [tempChildren addObject:imgSpec];
                }];
                
                layout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:5.0f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:tempChildren.copy];
                break;
            }
            case 5:
            case 6: {
                NSMutableArray *node1 = [NSMutableArray arrayWithCapacity:3];
                NSMutableArray *node2 = [NSMutableArray array];
                [self.picturesNodes enumerateObjectsUsingBlock:^(ASNetworkImageNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx < 3) {
                        [node1 addObject:obj];
                        return ;
                    }
                    [node2 addObject:obj];
                }];
                ASStackLayoutSpec *imgSpec1 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5.0f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:node1];
                
                ASStackLayoutSpec *imgSpec2 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5.0f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:node2];
                
                layout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:5.0f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[imgSpec1, imgSpec2]];
                break;
            }
            case 7:
            case 8:
            case 9: {
                NSMutableArray *node1 = [NSMutableArray arrayWithCapacity:3];
                NSMutableArray *node2 = [NSMutableArray arrayWithCapacity:3];
                NSMutableArray *node3 = [NSMutableArray array];
                [self.picturesNodes enumerateObjectsUsingBlock:^(ASNetworkImageNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx < 3) {
                        [node1 addObject:obj];
                        return ;
                    } else if (idx < 6) {
                        [node2 addObject:obj];
                        return;
                    }
                    [node3 addObject:obj];
                }];
                ASStackLayoutSpec *imgSpec1 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5.0f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:node1];
                
                ASStackLayoutSpec *imgSpec2 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5.0f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:node2];
                
                ASStackLayoutSpec *imgSpec3 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5.0f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:node3];
                
                layout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:5.0f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[imgSpec1, imgSpec2, imgSpec3]];
                break;
            }
        default:
            break;
    }
    _picturesLayout = layout;
    return layout;
}


- (NSMutableArray *)picturesNodes {
    if (_picturesNodes) {
        return _picturesNodes;
    }
    _picturesNodes = @[].mutableCopy;
    return _picturesNodes;
}
@end
