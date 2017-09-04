//
//  ViewController.m
//  InstagDown
//
//  Created by Luka on 2017/8/26.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <WebKit/WebKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


//static  NSString  *onePicturePost = @"https://www.instagram.com/p/BYObfLWACDK/";
//static NSString *onePicturePost = @"https://www.instagram.com/p/BYNzijDlwgo/";
static NSString *onePicturePost = @"https://www.instagram.com/p/BYNl3SOg3Re/";


static NSString *getSharedDataScriptString = @"webkit.messageHandlers.getSharedData.postMessage(window._sharedData);";
static NSString *handleMessageName = @"getSharedData";

@interface ViewController () <WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation ViewController

#pragma mark - WKScriptMessageHandler Delegate Method
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:handleMessageName]) {
        NSLog(@"%@", message.body[@"entry_data"][@"PostPage"][0][@"graphql"][@"shortcode_media"][@"display_url"]);
        NSLog(@"%@", [NSThread currentThread]);
        NSString *picURL = message.body[@"entry_data"][@"PostPage"][0][@"graphql"][@"shortcode_media"][@"display_url"];
        [self.image sd_setImageWithURL:[NSURL URLWithString:picURL]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = ({
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserScript *getSharedDataScript = [[WKUserScript alloc] initWithSource:getSharedDataScriptString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [configuration.userContentController addUserScript:getSharedDataScript];
        [configuration.userContentController addScriptMessageHandler:self name:handleMessageName];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration: configuration];
        
        [self.view addSubview:webView];
        webView;
    });
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    [self.image addGestureRecognizer:longPressGR];
    self.image.userInteractionEnabled = YES;
        // Do any additional setup after loading the view, typically from a nib.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        // URL
    NSURL *url = [NSURL URLWithString:onePicturePost];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
//            NSLog(@"%@ , %@", response, responseObject);
            NSData *htmlData = (NSData *)responseObject;
            NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", htmlString);
            NSString *filePathString = @"/Users/luka/Developer/Core Graphics/InstagDown/test.html";
            NSError *error = nil;
            [htmlString writeToFile:filePathString atomically:YES encoding:NSUTF8StringEncoding error:&error];
//            NSLog(@"%@", error);
            [self.webView loadHTMLString:htmlString baseURL:nil];
        }
    }];
    [dataTask resume];
}

- (void)saveImage:(UILongPressGestureRecognizer *)longPressGR {
    if (self.image.image != nil) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Save Image?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(self.image.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
        [controller addAction:saveAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:cancelAction];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"成功保存啦!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:cancelAction];
        [self presentViewController:controller animated:YES completion:nil];
    }
}


@end
