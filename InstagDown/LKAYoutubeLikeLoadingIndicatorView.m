//
//  LKAYoutubeLikeLoadingIndicatorView
//  youtube-like-spinner
//
//  Created by Luka on 2017/8/11.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "LKAYoutubeLikeLoadingIndicatorView.h"

static NSString *const kAnimationNameKey = @"LKAAnimationNameKey";
static NSString *const kStrokeStartAndEndAnimationName = @"strokeStartAndEndAnimation";
static NSString *const kRotateAnimation = @"rotateAnimation";

typedef void (^DisableImplictBlock) () ;

@interface LKAYoutubeLikeLoadingIndicatorView () <CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAAnimationGroup *strokeStartAndEndAnimation;
@property (nonatomic, strong) CABasicAnimation *rotateAnimation;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) NSUInteger currentColorIndex;
@end

@implementation LKAYoutubeLikeLoadingIndicatorView

#pragma mark - custom view initialization
- (void)initialization {
    [self setupPropertysInitValue];
    [self setupLayer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    return self;
}

#pragma mark - setup method

- (void)setupPropertysInitValue {
    _spinnerColors = @[
                            [UIColor colorWithRed:0.26 green:0.52 blue:0.96 alpha:1.00],
                            [UIColor colorWithRed:0.85 green:0.23 blue:0.17 alpha:1.00],
                            [UIColor colorWithRed:0.96 green:0.71 blue:0.00 alpha:1.00],
                            [UIColor colorWithRed:0.07 green:0.62 blue:0.35 alpha:1.00]
                       ];
    _lineWidth = 6.0;
    _hidesWhenStopped = NO;
    _isAnimating = NO;
    _currentColorIndex = 0;
}

- (void)setupLayer {
    _circleLayer = [CAShapeLayer layer];
    _circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    _circleLayer.fillColor = [UIColor clearColor].CGColor;
    [self changeColor];
    _circleLayer.lineWidth = 6;
    [self.layer addSublayer:_circleLayer];
}

- (void)updateLayer {
    CGFloat width = MIN(self.bounds.size.width, self.bounds.size.height);
    CGFloat radius = width / 2.0;
    CGRect rect = CGRectMake(CGRectGetMidX(self.bounds) - radius, CGRectGetMidY(self.bounds) - radius, width, width);
    self.circleLayer.frame = rect;
    self.circleLayer.path = [self circleLayerPath];
//    self.circleLayer.speed = 0.2;
    self.circleLayer.strokeStart = 0.0;
    self.circleLayer.strokeEnd = 0.0;
}

- (CGPathRef)circleLayerPath {
    CGFloat inset = self.circleLayer.lineWidth / 2.0;
    CGRect ovallRect = CGRectInset(self.circleLayer.bounds, inset, inset);
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat x = ovallRect.origin.x;
    CGFloat y = ovallRect.origin.y;
    CGFloat radius = ovallRect.size.width / 2.0;
    CGPoint center = CGPointMake(x + radius, y + radius);
    [path addArcWithCenter:center radius:radius startAngle:-M_PI_2 endAngle:3 * M_PI / 2.0 clockwise:YES];
    return path.CGPath;
}

#pragma mark - create animation

- (CAAnimationGroup *)strokeStartAndEndAnimation {
    if (!_strokeStartAndEndAnimation) {
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @0;
        strokeStartAnimation.toValue = @1;
        strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue = @0;
        strokeEndAnimation.toValue = @2;
        strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup *strokeStartAndEndAnimation = [CAAnimationGroup animation];
        strokeStartAndEndAnimation.duration = 2;
        strokeStartAndEndAnimation.animations = @[strokeStartAnimation, strokeEndAnimation];
        strokeStartAndEndAnimation.delegate = self;
        [strokeStartAndEndAnimation setValue:kStrokeStartAndEndAnimationName forKey:kAnimationNameKey];
        _strokeStartAndEndAnimation = strokeStartAndEndAnimation;
    }
    return _strokeStartAndEndAnimation;
}
 
- (CABasicAnimation *)rotateAnimation {
    if (!_rotateAnimation) {
        CABasicAnimation *rotateAnimation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.fromValue = @0;
        rotateAnimation.toValue = @(2 * M_PI);
        rotateAnimation.duration = 4;
        rotateAnimation.repeatCount = HUGE_VALF;
        rotateAnimation.removedOnCompletion = NO;
        _rotateAnimation = rotateAnimation;
    }
    return _rotateAnimation;
}

- (void)stopImplictAnimation:(DisableImplictBlock)block {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    block();
    [CATransaction commit];
}

#pragma mark - caanimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *animationName = [anim valueForKey:kAnimationNameKey];
    if ([animationName isEqualToString:kStrokeStartAndEndAnimationName]) {
        [self changeColor];
        if (self.isAnimating) {
             [self.circleLayer addAnimation:self.strokeStartAndEndAnimation forKey:@"strokeStartAndEndAnimation"];
        }
    }
}

#pragma mark - responder to the property setting
- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self stopImplictAnimation:^() {
        self.circleLayer.lineWidth = _lineWidth;
    }];
}

- (void)setSpinnerColors:(NSArray *)spinnerColors {
    _spinnerColors = [spinnerColors copy];
    _currentColorIndex = 0;
    if (!self.isAnimating) [self changeColor];
}

- (void)changeColor {
    NSAssert(self.spinnerColors.count != 0, @"You have to set one color at least!");
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    UIColor *currentColor = self.spinnerColors[self.currentColorIndex];
    self.circleLayer.strokeColor = currentColor.CGColor;
    self.currentColorIndex++;
    if (self.currentColorIndex  == self.spinnerColors.count) self.currentColorIndex = 0;
    [CATransaction commit];
}

- (void)hiddenLayer:(BOOL)isHidden {
    [self stopImplictAnimation:^{
        self.circleLayer.hidden = isHidden;
    }];
}

#pragma mark - view life's cycle method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayer];
}

- (void)savePresentationLayerStatus {
    CGFloat strokeStartBeforeStop = self.circleLayer.presentationLayer.strokeStart;
    CGFloat strokeEndBeforeStop = self.circleLayer.presentationLayer.strokeEnd;
    CGColorRef strokeColorBeforeStop = self.circleLayer.presentationLayer.strokeColor;
    NSNumber *radius = [self.circleLayer.presentationLayer valueForKeyPath:@"transform.rotation.z"];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.circleLayer.strokeStart = strokeStartBeforeStop;
    self.circleLayer.strokeEnd = strokeEndBeforeStop;
    self.circleLayer.strokeColor = strokeColorBeforeStop;
    [self.circleLayer setValue:radius forKeyPath:@"transform.rotation.z"];
    [CATransaction commit];
}

#pragma mark - public method
- (void)startAnimating {
    if (!self.isAnimating) {
        [self hiddenLayer:NO];

//        if (self.circleLayer.speed == 0.0) {
//            [self resumeAnimationOfLayer:self.circleLayer];
//        } else {
            [self.circleLayer addAnimation:self.strokeStartAndEndAnimation forKey:kStrokeStartAndEndAnimationName];
            [self.circleLayer addAnimation:self.rotateAnimation forKey: kRotateAnimation];
//        }
        self.isAnimating = YES;
    }
}

- (void)stopAnimating {
    if (self.isAnimating) {
//        [self savePresentationLayerStatus];
        [self hiddenLayer:self.hidesWhenStopped];
                [self.layer removeAllAnimations];
//        [self pauseAnimationOfLayer:self.circleLayer];
        self.isAnimating = NO;
//        [self.circleLayer removeAnimationForKey:kRotateAnimation];
//        [self.circleLayer removeAnimationForKey:kStrokeStartAndEndAnimationName];
    }
}

#pragma mark - pause and resume animation
- (void)pauseAnimationOfLayer:(CALayer *)layer {
    CFTimeInterval pauseTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pauseTime;
}

- (void)resumeAnimationOfLayer:(CALayer *)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}
@end
