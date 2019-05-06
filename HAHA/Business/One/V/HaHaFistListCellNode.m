//
//  HaHaFistLIstCellNode.m
//  笑笑
//
//  Created by Maker on 2019/3/28.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "HaHaFistListCellNode.h"
#import <YYCGUtilities.h>
//#import "POP.h"
#import "ASButtonNode+LHExtension.h"
#import "ZDDPhotoBrowseView.h"

@interface HaHaFistListCellNode ()

@property (nonatomic, strong) ASNetworkImageNode *iconNode;
@property (nonatomic, strong) ASTextNode *nameNode;
@property (nonatomic, strong) ASDisplayNode *lineNode;
@property (nonatomic, strong) ASButtonNode *thumbNode;
@property (nonatomic, strong) ASButtonNode *commentNode;

@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *timeNode;
@property (nonatomic, strong) ASLayoutSpec *picturesLayout;
@property (nonatomic, strong) NSMutableArray *picturesNodes;

/** <#class#> */
@property (nonatomic, strong) HaHaDuanziModel *model;
@end

@implementation HaHaFistListCellNode

- (instancetype)initWithModel:(HaHaDuanziModel *)model {
    if (self = [super init]) {
        self.model = model;
        if (model.content.length == 0) {
            model.content = @"请看图片";
        }
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addBackgroundNode];
        [self addTitleNode];
        [self addTimeNode];
        [self addPicturesNodesWithModel:model];
        
        [model addObserver:self forKeyPath:@"star_num" options:NSKeyValueObservingOptionNew context:nil];
        [model addObserver:self forKeyPath:@"comment_num" options:NSKeyValueObservingOptionNew context:nil];
        
        self.titleNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:model.content attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:16]).lh_color(color(53, 64, 72, 1));
        }];
        
        void(^attributes)(NSMutableDictionary *make) = ^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:12.0f]).lh_color([UIColor qmui_colorWithHexString:@"354048"]);
        };
        _thumbNode = [[ASButtonNode alloc] init];
        [_thumbNode lh_setEnlargeEdgeWithTop:10.0f right:15.0f bottom:10.0f left:15.0f];
        [_thumbNode setAttributedTitle:[NSMutableAttributedString lh_makeAttributedString:[NSString stringWithFormat:@"%ld", model.star_num] attributes:attributes] forState:UIControlStateNormal];
        [_thumbNode setImage:[UIImage imageNamed:@"disLike"] forState:UIControlStateNormal];
        [_thumbNode setImage:[UIImage imageNamed:@"like"] forState:UIControlStateSelected];
        [_thumbNode addTarget:self action:@selector(onTouchThumbNode) forControlEvents:ASControlNodeEventTouchUpInside];
        _thumbNode.selected = model.is_star;
        
        NSString *commentCount = [NSString stringWithFormat:@"%zd", model.comment_num];

        _commentNode = [[ASButtonNode alloc] init];
        [_thumbNode lh_setEnlargeEdgeWithTop:10.0f right:15.0f bottom:10.0f left:15.0f];
        [_commentNode setAttributedTitle:[NSMutableAttributedString lh_makeAttributedString:commentCount attributes:attributes] forState:UIControlStateNormal];
        [_commentNode setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        
        [self addSubnode:_thumbNode];
        [self addSubnode:_commentNode];
        
        self.timeNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:[self formatFromTS:model.create_date] attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:12]).lh_color(color(53, 64, 72, 1));
        }];
        
    }
    return self;
}

- (void)dealloc {
    [self.model removeObserver:self forKeyPath:@"star_num"];
    [self.model removeObserver:self forKeyPath:@"comment_num"];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    _thumbNode.selected =  self.model.is_star;
    void(^attributes)(NSMutableDictionary *make) = ^(NSMutableDictionary *make) {
        make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:12.0f]).lh_color([UIColor qmui_colorWithHexString:@"354048"]);
    };
    [_thumbNode setAttributedTitle:[NSMutableAttributedString lh_makeAttributedString:[NSString stringWithFormat:@"%ld", self.model.star_num] attributes:attributes] forState:UIControlStateNormal];
    
    NSString *commentCount = [NSString stringWithFormat:@"%zd", self.model.comment_num];
    
    [_commentNode setAttributedTitle:[NSMutableAttributedString lh_makeAttributedString:commentCount attributes:attributes] forState:UIControlStateNormal];
}

- (NSString *)formatFromTS:(NSInteger)ts {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *str = [NSString stringWithFormat:@"%@",
                     [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ts]]];
    return str;
}

//点击图片
- (void)onTouchPictureNode:(ASNetworkImageNode *)imgNode {
    
    __block NSInteger currentIndex = 0;
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:self.picturesNodes.count];
    [self.picturesNodes enumerateObjectsUsingBlock:^(ASNetworkImageNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LHPhotoGroupItem *item = [[LHPhotoGroupItem alloc]init];
        YYAnimatedImageView * animatedIV = [[YYAnimatedImageView alloc] init];
        animatedIV.image = obj.image;
        item.thumbView = animatedIV;
        item.largeImageURL = obj.URL;
        [tempArr addObject:item];
        if (obj == imgNode) {
            currentIndex = idx;
        }
    }];
    
    UIView *fromView = [imgNode view];
    
    
    ZDDPhotoBrowseView *photoGroupView = [[ZDDPhotoBrowseView alloc] initWithGroupItems:tempArr.copy];
    [photoGroupView.pager removeFromSuperview];
    photoGroupView.fromItemIndex = currentIndex;
    photoGroupView.backtrack = YES;
    [photoGroupView presentFromImageView:fromView
                             toContainer:[UIApplication sharedApplication].keyWindow
                                animated:YES
                              completion:nil];
    
}

//点赞
- (void)onTouchThumbNode {
    if ([GODUserTool shared].user.user_id.length == 0) {
        [MFHUDManager showError:@"请先登录"];
        return;
    }
    self.model.is_star = !self.model.is_star;
    if (self.model.is_star) {
        self.model.star_num += 1;
    }else {
        self.model.star_num -= 1;
    }
   
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;
    [MFNETWROK post:@"Star/AddOrCancel" params:@{@"targetId" : self.model.id, @"userId" : [GODUserTool shared].user.user_id} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
       
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        
    }];
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *titleAndImgSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    if (self.picturesNodes.count) {
        titleAndImgSpec.spacing = 10;
        titleAndImgSpec.children = @[self.picturesLayout, self.titleNode];
    }
    ASStackLayoutSpec *commentSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    commentSpec.spacing = 12;
    commentSpec.alignItems = ASStackLayoutAlignItemsCenter;
    commentSpec.children = @[self.commentNode, self.thumbNode];
    
    ASStackLayoutSpec *timeSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    timeSpec.spacing = 6;
    timeSpec.justifyContent = ASStackLayoutJustifyContentSpaceBetween;
    timeSpec.alignItems = ASStackLayoutAlignItemsEnd;
    timeSpec.children = @[self.timeNode, commentSpec];
    
    ASStackLayoutSpec *titleAndCommentSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    titleAndCommentSpec.spacing = 15;
    if (self.picturesNodes.count) {
        titleAndCommentSpec.children = @[titleAndImgSpec, timeSpec];
    }else {
        titleAndCommentSpec.children = @[self.titleNode, timeSpec];
    }
    
    ASStackLayoutSpec *lineSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    lineSpec.spacing = 15;
    lineSpec.children = @[titleAndCommentSpec, self.lineNode];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(20, 20, 0, 20) child:lineSpec];
    
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

- (void)addTimeNode {
    self.timeNode = [ASTextNode new];
    self.timeNode.style.maxWidth = ASDimensionMake(SCREENWIDTH - 60);
    [self addSubnode:self.timeNode];
}

- (void)addPicturesNodesWithModel:(HaHaDuanziModel *)model {
    CGSize itemSize = [self pictureSizeWithCount:model.picture_path.count imageSize:CGSizeMake(ScreenWidth/3.0, ScreenWidth/3.0)];
    
    [model.picture_path enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ASNetworkImageNode *pictureNode = [ASNetworkImageNode new];
        pictureNode.style.preferredSize = itemSize;
        pictureNode.cornerRadius = 6;
        pictureNode.contentMode = UIViewContentModeScaleAspectFit;
        pictureNode.backgroundColor = [UIColor qmui_colorWithHexString:@"F8F8F8"];
        pictureNode.defaultImage = [self placeholderImage];
        pictureNode.contentMode = UIViewContentModeScaleAspectFill;
        pictureNode.URL = [NSURL URLWithString:obj];
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
        default: {
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
