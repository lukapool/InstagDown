//
//  MediaShowView.m
//  InstagDown
//
//  Created by Luka on 2017/9/5.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "MediaShowView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking.h>

@interface MediaShowView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CAShapeLayer *loadingLayer;
@property (nonatomic, strong) CAShapeLayer *indicateLayer;
@property (nonatomic, strong) AFURLSessionManager *videoDownloadManager;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) UIImageView *imageType;
@end

@implementation MediaShowView

- (AFURLSessionManager *)videoDownloadManager {
    if (!_videoDownloadManager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _videoDownloadManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _videoDownloadManager;
}

#pragma mark - custom view initialization
- (void)initailzation {
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0].active = YES;
        [imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0].active = YES;
        [imageView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0].active = YES;
        [imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0].active = YES;
        imageView;
    });
    
    self.loadingLayer = ({
        CAShapeLayer *loadingLayer = [CAShapeLayer layer];
        loadingLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:loadingLayer];
        loadingLayer.strokeColor = [UIColor whiteColor].CGColor;
        loadingLayer.fillColor = [UIColor clearColor].CGColor;
        loadingLayer.lineWidth = 5;
        loadingLayer;
    });
    
    self.loadingLayer.hidden = YES;
    self.indicateLayer = ({
        CAShapeLayer *indicateLayer = [CAShapeLayer layer];
        indicateLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.loadingLayer addSublayer:indicateLayer];
        indicateLayer.strokeColor = [UIColor blackColor].CGColor;
        indicateLayer.fillColor = [UIColor clearColor].CGColor;
        indicateLayer.lineWidth = 5;
        indicateLayer.strokeStart = 0.0;
        indicateLayer.strokeEnd = 0.0;
        indicateLayer;
    });
    
    self.imageType = ({
        UIImageView *imageType = [[UIImageView alloc] init];
        [self addSubview:imageType];
        imageType.contentMode = UIViewContentModeScaleAspectFit;
        imageType.translatesAutoresizingMaskIntoConstraints = NO;
        [imageType.widthAnchor constraintEqualToConstant:20].active = YES;
        [imageType.heightAnchor constraintEqualToConstant:20].active = YES;
        [imageType.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10].active = YES;
        [imageType.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:10].active = YES;
        imageType;
    });
}

- (void)setMedia:(IGMedia *)media {
    _media = media;

    if (media.mediaType == IGMediaTypeVideo) {
        self.imageType.image = [UIImage imageNamed:@"mp4"];
        [self downloadVideo];
    } else if (media.mediaType == IGMediaTypeImage) {
        self.imageType.image = [UIImage imageNamed:@"image"];
        [self downloadImage];
    }
}

- (void)downloadVideo {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.media.previewURL] placeholderImage:nil options:SDWebImageRetryFailed];
    self.loadingLayer.hidden = NO;
        // download video
    NSURL *url = [NSURL URLWithString:self.media.sourceURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.downloadTask = [self.videoDownloadManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        self.indicateLayer.strokeEnd = downloadProgress.fractionCompleted;
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"%@", filePath);
        if (error) {
            self.indicateLayer.strokeEnd = 0.0;
        } else {
            self.media.savePath = filePath;
            [self.loadingLayer removeFromSuperlayer];
        }
    }];
    [self.downloadTask resume];
    
}

- (void)downloadImage {
    self.loadingLayer.hidden = NO;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.media.previewURL] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        self.indicateLayer.strokeEnd = (CGFloat)receivedSize / expectedSize;
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            self.indicateLayer.strokeEnd = 0.0;
        } else {
            NSLog(@"%@", imageURL);
            NSString *path = [[SDWebImageManager sharedManager].imageCache defaultCachePathForKey:imageURL.absoluteString];
            self.media.savePath = [NSURL URLWithString: path];
            [self.loadingLayer removeFromSuperlayer];
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initailzation];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initailzation];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    self.loadingLayer.frame = CGRectMake(width * 0.3, width * 0.3, width * 0.4, width * 0.4);
    self.loadingLayer.path = [self backgroundPath];
    self.indicateLayer.frame = self.loadingLayer.bounds;
    self.indicateLayer.path = [self indicatePath];
}

- (CGPathRef)backgroundPath {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.loadingLayer.bounds];
    return path.CGPath;
}

- (CGPathRef)indicatePath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(CGRectGetMidX(self.loadingLayer.bounds), CGRectGetMidY(self.loadingLayer.bounds)) radius:CGRectGetWidth(self.loadingLayer.bounds) / 2.0 startAngle:-M_PI_2 endAngle:3 * M_PI_2 clockwise:YES];
    return path.CGPath;
}

@end
