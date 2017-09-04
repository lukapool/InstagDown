//
//  IGPost.h
//  InstagDown
//
//  Created by Luka on 2017/9/2.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGUser.h"
#import "IGMedia.h"

typedef NS_ENUM(NSUInteger, IGPostType) {
    IGPostTypeGraphNone,
    IGPostTypeGraphImage,
    IGPostTypeGraphVideo,
    IGPostTypeGraphSidecar
};

@interface IGPost : NSObject

@property (nonatomic, strong) IGUser *user;
@property (nonatomic, assign) IGPostType postType;
@property (nonatomic, copy) NSString *shortcode;
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, copy, readonly) NSArray *medias;

+ (instancetype)postWithDic:(NSDictionary *)dict;
- (instancetype)initWithUser:(IGUser *)user postType:(IGPostType)postType shortcode:(NSString *)shortcode timestamp:(NSTimeInterval)timestamp andMedias:(NSArray *)mediaArray;
@end
