//
//  IGMedia.h
//  InstagDown
//
//  Created by Luka on 2017/9/2.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IGMediaType) {
    IGMediaTypeImage,
    IGMediaTypeVideo
};

@interface IGMedia : NSObject

@property (nonatomic, assign) IGMediaType mediaType;
@property (nonatomic, copy) NSString *shortcode;
@property (nonatomic, assign) CGFloat meidaHeight;
@property (nonatomic, assign) CGFloat meidaWidth;
@property (nonatomic, copy) NSString *previewURL;
@property (nonatomic, copy) NSString *sourceURL;

- (instancetype)initWithMediaType:(IGMediaType)mediaType shortcode:(NSString *)shortcode mediaHeight:(CGFloat)mediaHeight mediaWidth:(CGFloat)mediaWidth previewURL:(NSString *)previewURL andSourceURL:(NSString *)sourceURL;
+ (instancetype)mediaWithDic:(NSDictionary *)dict;

@end
