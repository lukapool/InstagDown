//
//  IGPost.m
//  InstagDown
//
//  Created by Luka on 2017/9/2.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "IGPost.h"
#import "IGUser.h"
#import "IGMedia.h"

@interface IGPost ()

@end

@implementation IGPost

+ (instancetype)postWithDic:(NSDictionary *)dict {
    IGUser *user = [IGUser userWithDic:dict[@"graphql"][@"shortcode_media"][@"owner"]];

    NSString *shortcode = dict[@"graphql"][@"shortcode_media"][@"shortcode"];
    NSNumber *number = dict[@"graphql"][@"shortcode_media"][@"taken_at_timestamp"];
    NSTimeInterval timestamp = [number doubleValue];
    
    NSMutableArray *mediaArray = [NSMutableArray array];
    IGPostType postType = IGPostTypeGraphNone;
    NSString *typeName = dict[@"graphql"][@"shortcode_media"][@"__typename"];
    if ([typeName isEqualToString:@"GraphImage"]) {
        postType = IGPostTypeGraphImage;
        IGMedia *media = [IGMedia mediaWithDic: dict[@"graphql"][@"shortcode_media"]];
        [mediaArray addObject: media];
    } else if ([typeName isEqualToString:@"GraphVideo"]) {
        postType = IGPostTypeGraphVideo;
        IGMedia *media = [IGMedia mediaWithDic: dict[@"graphql"][@"shortcode_media"]];
        [mediaArray addObject: media];
    } else if ([typeName isEqualToString:@"GraphSidecar"]) {
        postType = IGPostTypeGraphSidecar;
        NSArray *mediaArrayData = dict[@"graphql"][@"shortcode_media"][@"edge_sidecar_to_children"][@"edges"];
        for (NSDictionary *node in mediaArrayData) {
            IGMedia *media = [IGMedia mediaWithDic: node[@"node"]];
            [mediaArray addObject: media];
        }
    }
    
    return [[[self class] alloc] initWithUser:user postType:postType shortcode:shortcode timestamp:timestamp andMedias:mediaArray];
}

- (instancetype)initWithUser:(IGUser *)user postType:(IGPostType)postType shortcode:(NSString *)shortcode timestamp:(NSTimeInterval)timestamp andMedias:(NSArray *)mediaArray {
    self = [super init];
    if (self) {
        self.user = user;
        self.postType = postType;
        self.shortcode = shortcode;
        self.timestamp = timestamp;
        _medias = [mediaArray copy];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[POST]\n\tUser:%@\n\tPostType:%ld\n\tShortCode:%@\n\tTimeInterval:%lf\n\tMedias:%@", _user,  _postType, _shortcode, _timestamp, _medias];
}
@end



























