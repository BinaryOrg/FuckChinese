//
//  GODWebViewController.m
//  笑笑
//
//  Created by 张冬冬 on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "GODWebViewController.h"
#import <WebKit/WebKit.h>
@interface GODWebViewController ()
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation GODWebViewController

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"看点";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
}

@end
