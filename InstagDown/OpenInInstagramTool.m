//
//  OpenInInstagramTool.m
//  InstagDown
//
//  Created by Luka on 2017/8/30.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "OpenInInstagramTool.h"
static NSString *OPEN_URL_INSTAGRAM_APP = @"instagram://app";
static NSString *OPEN_URL_INSTAGRAM_WEB =  @"https://www.instagram.com";
static NSString *OPEN_URL_INSTAGRAM_MEDIA_ID = @"instagram://media?id=";
static NSString *OPEN_URL_INSTAGRAM_USER_NAME = @"instagram://user?username=";


@implementation OpenInInstagramTool

+ (void)openIGApp {
    [[self class] openIGURLWithString:OPEN_URL_INSTAGRAM_APP failWithString:OPEN_URL_INSTAGRAM_WEB];
}

+ (void)openIGAppByMediaID:(NSString *)mediaID {
    unsigned long long int mediaid =  [self mediaIDFromShortCode:mediaID];
    [[self class] openIGURLWithString: [NSString stringWithFormat:@"%@%llu", OPEN_URL_INSTAGRAM_MEDIA_ID, mediaid] failWithString:[NSString stringWithFormat:@"%@/p/%@", OPEN_URL_INSTAGRAM_WEB, mediaID]];
}

+ (void)openIGAppByUserName:(NSString *)userName {
   [[self class] openIGURLWithString: [NSString stringWithFormat:@"%@%@", OPEN_URL_INSTAGRAM_USER_NAME, userName] failWithString:[NSString stringWithFormat:@"%@/%@", OPEN_URL_INSTAGRAM_WEB, userName]];
}


+ (void)openIGURLWithString:(NSString *)urlString failWithString:(NSString *)httpString {
//    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:url]) {
        [application openURL:url options:@{} completionHandler:nil];
    } else {
        [application openURL:[NSURL URLWithString:httpString] options:@{} completionHandler:nil];
    }
}

+ (unsigned long long int)mediaIDFromShortCode:(NSString *)shortcode {
    unsigned long long int medaID = 0;
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
    for (NSUInteger i = 0; i < shortcode.length; i++) {
        unichar currentChar = [shortcode characterAtIndex:i];
        NSRange range = [alphabet rangeOfString:[NSString stringWithFormat:@"%c", currentChar]];
        medaID = (medaID * 64) + range.location;
    }
    return medaID;
}
@end
