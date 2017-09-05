//
//  PostView.m
//  InstagDown
//
//  Created by Luka on 2017/9/1.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "PostView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "MediaShowView.h"



@interface PostView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *backgroundView;
@property (assign, nonatomic) NSTimeInterval duration;
@property (copy, nonatomic) CompleteBlock block;
@property (weak, nonatomic) IBOutlet UIScrollView *sidecar;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *previewsArray;

@end

@implementation PostView

- (void)setPost:(IGPost *)post {
    _post = post;
    [self updateUI];
}

- (void)updateUI {
    NSLog(@"%@", [[SDWebImageManager sharedManager].imageCache defaultCachePathForKey:nil]);
    [[SDWebImageManager sharedManager] cancelAll];
    self.username.text = self.post.user.username;
    
    [self.profileImage sd_setShowActivityIndicatorView:YES];
    [self.profileImage sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:self.post.user.profilePicURL] placeholderImage:nil options:SDWebImageRetryFailed];
    
    NSUInteger mediaCount = self.post.medias.count;
    [self.pageControl setNumberOfPages:mediaCount];
    self.pageControl.currentPage = 0;
    
    [self.previewsArray enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self.previewsArray removeAllObjects];
    
    CGFloat width = self.bounds.size.width;
    
    for (NSUInteger i = 0; i < mediaCount; i++) {
        IGMedia *media = self.post.medias[i];
        MediaShowView *mediaShowView = [[MediaShowView alloc] init];
        mediaShowView.media = media;
        [self.sidecar addSubview:mediaShowView];
        [self.previewsArray addObject:mediaShowView];
        
        mediaShowView.frame = CGRectMake(i * width, 0, width, width);
    }
    
    self.sidecar.contentSize = CGSizeMake(width * mediaCount, 0);
    
}

- (NSMutableArray *)previewsArray {
    if (!_previewsArray) {
        _previewsArray = [NSMutableArray array];
    }
    return _previewsArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(NO, @"not implement initWithCoder:");
    self = [super initWithCoder:aDecoder];
    return self;
}

- (UIView *)loadViewFromXib {
    UIView *contentView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    return contentView;
}

- (void)setup {
    // setup container view
    self.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 4;
    // content view
    self.contentView = [self loadViewFromXib];
    self.contentView.frame = self.bounds;
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    // setup profile image
    self.profileImage.layer.cornerRadius = 22.0;
    self.profileImage.layer.masksToBounds = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageDidTap:)];
    [self.profileImage addGestureRecognizer:tapGR];
    // setup backgroundView
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView.layer.cornerRadius = 5.0;
    [self addSubview:self.backgroundView];
    // setup propery
    self.duration = 1.0;
    
    [self perspectiveTransformForContainerView:self];
    
        // setup scroll view
    self.sidecar.delegate = self;
    
}

- (CATransform3D)yRotation:(CGFloat)rotation {
    CATransform3D transform = CATransform3DMakeRotation(rotation, 0, -1, 0);
    return transform;
}

- (void)perspectiveTransformForContainerView:(UIView *)containerView {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 0.0005;
    self.layer.sublayerTransform = transform;
}

- (void)filpFromView:(UIView *)fromView toView:(UIView *)toView withDuration:(NSTimeInterval)duration complete:(CompleteBlock)block {
    self.block = block;
    toView.layer.transform = [self yRotation:M_PI_2];
//    toView.alpha = 1.0;
    toView.hidden = NO;
    [UIView animateKeyframesWithDuration:duration delay:0.0 options: UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            fromView.layer.transform = [self yRotation:-M_PI_2];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            toView.layer.transform = [self yRotation:0];
        }];
    } completion:^(BOOL finished) {
//        fromView.alpha = 0.0;
        fromView.hidden = YES;
        fromView.layer.transform = CATransform3DIdentity;
        toView.layer.transform = CATransform3DIdentity;
        if (self.block) {
            self.block();
        }

    }];
}

- (void)showPostWithBlock:(CompleteBlock)block {
    if (!self.backgroundView.isHidden) {
        [self filpFromView:self.backgroundView toView:self.contentView withDuration:self.duration complete: block];
    } else {
        if (block) block();
    }
}

- (void)hidePostWithBlock:(CompleteBlock)block {
    if (self.backgroundView.isHidden) {
        [self filpFromView:self.contentView toView:self.backgroundView withDuration:self.duration / 2.0 complete:block];
    } else {
        if (block) block();
    }
}

- (IBAction)more:(UIButton *)sender {
    [self.delegate postViewDidClickMore:self];
}

- (IBAction)saveMedia:(UIButton *)sender {
    [self.delegate postViewDidClickSave:self withIGMedia:[self whichMedia]];
}

- (IBAction)share:(UIButton *)sender {
    [self.delegate postViewDidClickShare:self withActivityItems:@[self.profileImage.image]];
}

- (IGMedia *)whichMedia {
    NSUInteger currentPage = self.pageControl.currentPage;
    return self.post.medias[currentPage];
}

- (void)profileImageDidTap:(UITapGestureRecognizer *)gr {
    [self.delegate postView:self didTapProfileImag:self.profileImage];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat endX = targetContentOffset->x;
    NSUInteger currentIndex = (NSUInteger)(endX / self.bounds.size.width);
    self.pageControl.currentPage = currentIndex;
}
@end
