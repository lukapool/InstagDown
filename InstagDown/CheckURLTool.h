//
//  CheckURLTool.h
//  InstagDown
//
//  Created by Luka on 2017/9/4.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ExtractURLType) {
    ExtractEmptyURL,
    ExtractInvalidURL,
    ExtractValid
};

@interface CheckURLTool : NSObject

+ (NSString *)checkURLString:(NSString *)urlString withExtractURLType:(ExtractURLType *)type;

@end
