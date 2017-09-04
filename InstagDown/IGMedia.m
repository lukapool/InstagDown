//
//  IGMedia.m
//  InstagDown
//
//  Created by Luka on 2017/9/2.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "IGMedia.h"

@implementation IGMedia

- (instancetype)initWithMediaType:(IGMediaType)mediaType shortcode:(NSString *)shortcode mediaHeight:(CGFloat)mediaHeight mediaWidth:(CGFloat)mediaWidth previewURL:(NSString *)previewURL andSourceURL:(NSString *)sourceURL {
    self = [super init];
    if (self) {
        self.mediaType = mediaType;
        self.shortcode = shortcode;
        self.meidaHeight = mediaHeight;
        self.meidaWidth = mediaWidth;
        self.previewURL = previewURL;
        self.sourceURL = sourceURL;
    }
    return self;
}

+ (instancetype)mediaWithDic:(NSDictionary *)dict {
    NSNumber *isVideo = dict[@"is_video"];
    IGMediaType mediaType = IGMediaTypeImage;
    
    NSString *previewURL = dict[@"display_url"];
    NSString *sourceURL = previewURL;
    if (isVideo.boolValue) {
        mediaType = IGMediaTypeVideo;
        sourceURL = dict[@"video_url"];
    }
    
    NSString *shortcode = dict[@"shortcode"];
    
    CGFloat mediaHeight = [dict[@"dimensions"][@"height"] floatValue];
    CGFloat mediaWidth = [dict[@"dimensions"][@"width"] floatValue];
    
    return [[[self class] alloc] initWithMediaType:mediaType shortcode:shortcode mediaHeight:mediaHeight mediaWidth:mediaWidth previewURL:previewURL andSourceURL:sourceURL];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[MEDIA]\n\tMediaType:%ld\n\tShortcode:%@\n\tHeight:%lf\n\tWidth:%lf\n\tPreviewURL:%@\n\tSourceURL:%@", _mediaType, _shortcode, _meidaHeight, _meidaWidth, _previewURL, _sourceURL];
}

@end
