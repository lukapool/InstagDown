//
//  DownloadViewController.m
//  InstagDown
//
//  Created by Luka on 2017/8/29.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "DownloadViewController.h"
#import "MACRO.h"
#import "OpenInInstagramTool.h"
#import "ExtractView.h"
#import <CWStatusBarNotification/CWStatusBarNotification.h>
#import <AFNetworking.h>
#import "PostView.h"
#import "IGPost.h"
#import "CheckURLTool.h"

@interface DownloadViewController () <ExtractViewDelegate, PostViewDelegate>
@property (nonatomic, strong) CWStatusBarNotification *notification;
@property (nonatomic, strong) ExtractView *extractView;
@property (nonatomic, strong) AFHTTPSessionManager *networkingManager;

@property (nonatomic, strong) NSLayoutConstraint *extractYContraint;

@property (nonatomic, strong) PostView *postView;
@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custom];
    [self setupPostView];
    [self setupExtractView];

    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (pasteboard.hasStrings) {
        NSString *copyString = pasteboard.string;
        NSLog(@"%@", copyString);
        ExtractURLType type;
        NSString *newString = [CheckURLTool checkURLString:copyString withExtractURLType:&type];
        if (type == ExtractValid) {
            UIAlertController *tipController = [UIAlertController alertControllerWithTitle:@"Tip" message:@"URL stirng was detected. Use it?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *useAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                self.extractView.inputTextField.text = newString;
                [self.notification displayNotificationWithMessage:@"Input URL From Pasteboard" forDuration:3.0];
                pasteboard.string = @"";
            }];
            [tipController addAction:useAction];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
            [tipController addAction:cancel];
            [self presentViewController:tipController animated:YES completion:nil];
        }
    }
}

- (void)setupPostView {
    self.postView = ({
        PostView *postView = [[PostView alloc] init];
        postView.translatesAutoresizingMaskIntoConstraints = NO;
        postView.alpha = 0.0;
        [self.view addSubview:postView];
        postView;
    });
    
//    [self.postView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
//    [self.postView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.postView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:130].active = YES;
    [self.postView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:20].active = YES;
    [self.postView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-20].active = YES;
//    [self.postView.heightAnchor constraintEqualToAnchor:self.postView.widthAnchor multiplier:1].active = YES;
    self.postView.delegate = self;
    
}

/**
 set up extract view
 */
- (void)setupExtractView {
    self.extractView = ({
        ExtractView *extractView = [[ExtractView alloc] init];
        [self.view addSubview:extractView];
        extractView.delegate = self;
        [extractView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        self.extractYContraint = [extractView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:0];
        self.extractYContraint.active = YES;
        [extractView.heightAnchor constraintEqualToConstant:40].active = YES;
        [extractView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:EXTRACT_VIEW_PADDING].active = YES;
        [extractView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-EXTRACT_VIEW_PADDING].active = YES;

        extractView;
    });
}

- (CWStatusBarNotification *)notification {
    if (!_notification) {
        _notification = [[CWStatusBarNotification alloc] init];
        _notification.notificationLabelBackgroundColor = [UIColor blackColor];
        _notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
        _notification.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
        _notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
        _notification.notificationLabelFont = [UIFont fontWithName:@"Billabong" size:30];
        _notification.notificationLabel.textColor = [UIColor whiteColor];
    }
    return _notification;
}

- (AFHTTPSessionManager *)networkingManager {
    if (!_networkingManager) {
        _networkingManager = [AFHTTPSessionManager manager];
        [_networkingManager willChangeValueForKey:@"timeoutInterval"];
        _networkingManager.requestSerializer.timeoutInterval = 10.0f;
        [_networkingManager didChangeValueForKey:@"timeoutInterval"];
        _networkingManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:kNilOptions];
    }
    return _networkingManager;
}
/**
 custom tab bar item
 background color
 navigation bar
 */
- (void)custom {
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"Download_normal"] selectedImage:[UIImage imageNamed:@"Download_highlight"]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    self.view.backgroundColor = COLOR_BACKGROUND;
    
    [self.navigationController.navigationBar setBarTintColor:COLOR_BACKGROUND];
    self.navigationController.navigationBar.clipsToBounds = YES;
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 49)];
    titleView.textAlignment = NSTextAlignmentCenter;
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 2.0;
    shadow.shadowOffset = CGSizeMake(2.0, 2.0);
    shadow.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    NSDictionary *attributeDict = @{
                                    NSFontAttributeName: [UIFont fontWithName:@"Billabong" size:35],
                                    NSBaselineOffsetAttributeName: @2,
                                    NSShadowAttributeName: shadow
                                    };
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"Instagdown" attributes:attributeDict];

    titleView.attributedText = string;
//    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;

    UIButton *gotoInstagramBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [gotoInstagramBtn addTarget:self action:@selector(gotoInstagram:) forControlEvents:UIControlEventTouchUpInside];
    [gotoInstagramBtn setBackgroundImage:[UIImage imageNamed:@"instagramlogo"] forState:UIControlStateNormal];
    
    [self.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithCustomView: gotoInstagramBtn]];
}

/**
 open instagram app

 @param sender UIButton
 */
- (void)gotoInstagram:(id)sender {
    NSLog(@"go to instagram app");
    [OpenInInstagramTool openIGApp];
}

#pragma mark - Post View  Delegate
- (void)postViewDidClickShare:(PostView *)postView withActivityItems:(NSArray *)items {
    UIActivityViewController *activityCV = [[UIActivityViewController alloc] initWithActivityItems:[items copy] applicationActivities:nil];
//    activityCV.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
//        
//    };
    [self presentViewController:activityCV animated:YES completion:nil];
}

- (void)postViewDidClickSave:(PostView *)postView {
    
}

- (void)postViewDidClickMore:(PostView *)postView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    UIAlertAction *openUserHomePageAction = [UIAlertAction actionWithTitle:@"Open User Home Page" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [OpenInInstagramTool openIGAppByUserName:postView.post.user.username];
    }];
    [alertController addAction:openUserHomePageAction];

    UIAlertAction *openPostPageAction = [UIAlertAction actionWithTitle:@"Open Post  Page" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [OpenInInstagramTool openIGAppByMediaID:postView.post.shortcode];
    }];
    [alertController addAction:openPostPageAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)postView:(PostView *)postView didTapProfileImag:(UIImageView *)profileImageView {
    
}

#pragma mark - Extract View Delegate
- (void)extractViewDidCallExtract:(ExtractView *)extractView withValidURL:(NSURL *)postURL {
    NSLog(@"%s", __func__);
        // request
    __weak typeof(self) weakSelf = self;
    [self.postView hidePostWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.networkingManager GET:postURL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            IGPost *post = [IGPost postWithDic:responseObject];
            NSLog(@"%@", post);
            strongSelf.postView.post = post;
            if (strongSelf.extractYContraint) {
                strongSelf.extractYContraint.active = NO;
                strongSelf.extractYContraint = nil;
                [strongSelf.extractView.topAnchor constraintEqualToAnchor:strongSelf.view.topAnchor constant:70].active = YES;
                [UIView animateWithDuration:0.6  delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [strongSelf.view layoutIfNeeded];
                    strongSelf.postView.alpha = 1.0;
                } completion:^(BOOL finished) {
                    [strongSelf.postView showPostWithBlock:^{
                        [strongSelf.extractView cancellLoading];
                    }];
                }];
            } else {
                [strongSelf.postView showPostWithBlock:^{
                    [strongSelf.extractView cancellLoading];
                }];
            }
            
//            NSLog(@"%@", responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == -1001) {
                [strongSelf.notification displayNotificationWithMessage:@"Timeout   Try  Again" forDuration:3.0];
            } else {
                [strongSelf.notification displayNotificationWithMessage:@"Error" forDuration:3.0];
            }

            [strongSelf.postView hidePostWithBlock:^{
                [strongSelf.extractView cancellLoading];
            }];
        }];

    }];

}

- (void)extractViewDidCallExtractWithEmptyURL:(ExtractView *)extractView {
    NSLog(@"%s", __func__);
    [self.notification displayNotificationWithMessage:@"No URL Input" forDuration:3.0];
}

- (void)extractViewDidCallExtractWithInvalidURL:(ExtractView *)extractView {
     NSLog(@"%s", __func__);
    [self.notification displayNotificationWithMessage:@"Invalid URL Input" forDuration:3.0];
}

@end
