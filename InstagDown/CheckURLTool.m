//
//  CheckURLTool.m
//  InstagDown
//
//  Created by Luka on 2017/9/4.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "CheckURLTool.h"
static NSString *kPostUrlPrefixOne = @"https://www.instagram.com/p/";
static NSString *kPostUrlPrefixTwo = @"https://instagram.com/p/";

@implementation CheckURLTool

+ (NSString *)checkURLString:(NSString *)urlString withExtractURLType:(ExtractURLType *)type{
    if (urlString == nil) {
        *type = ExtractEmptyURL;
    } else {
        urlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        if ([urlString isEqualToString:@""]) {
            *type = ExtractEmptyURL;
        } else if ([urlString hasPrefix:kPostUrlPrefixOne] || [urlString hasPrefix:kPostUrlPrefixTwo]) {
            *type = ExtractValid;
        } else {
            *type = ExtractInvalidURL;
        }
    }
    NSRange range = [urlString rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        urlString = [urlString substringToIndex:range.location];
    }
    return urlString;
}
@end
