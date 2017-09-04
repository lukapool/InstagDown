//
//  ExtractView.m
//  InstagDown
//
//  Created by Luka on 2017/8/30.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "ExtractView.h"

#import "MACRO.h"
#import "LKAYoutubeLikeLoadingIndicatorView.h"
#import "CheckURLTool.h"





@interface ExtractView ()

@property (nonatomic, strong) UIView *extractBtn;
@property (nonatomic, strong) UILabel *extractLabel;

@property (nonatomic, strong) NSLayoutConstraint *widthBtnConstraint;


@property (nonatomic, assign) CGFloat widthBtn;

@property (nonatomic, copy, readonly) NSString *postURLString;
@property (nonatomic, assign) ExtractURLType currentURLType;

@property (nonatomic, strong) LKAYoutubeLikeLoadingIndicatorView *loadingIndicatorView;

@end

@implementation ExtractView

#pragma mark - custom view initialization
- (void)initialization {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self setupTextField];
    [self setupExtractBtn];
   
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


- (void)setupExtractBtn {
        // extract flag default
    self.extracting = NO;
    
    self.extractBtn = ({
        UIView *extractBtn = [[UIView alloc] init];
        [self addSubview:extractBtn];
        extractBtn.translatesAutoresizingMaskIntoConstraints = NO;
        extractBtn.backgroundColor = [UIColor whiteColor];
        extractBtn.layer.cornerRadius = INPUT_FIELD_CORNER_RADIUS;
        extractBtn.layer.borderColor = [UIColor blackColor].CGColor;
        extractBtn.layer.borderWidth = 2;
        extractBtn;
    });

    [self.extractBtn.heightAnchor constraintEqualToConstant:2 * INPUT_FIELD_CORNER_RADIUS].active = YES;
    [self.extractBtn.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    self.widthBtnConstraint = [self.extractBtn.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.2];
    self.widthBtnConstraint.active = YES;
    
    [self.extractBtn.leftAnchor constraintEqualToAnchor:self.inputTextField.rightAnchor constant:10].active = YES;
    [self.extractBtn.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;

    
    self.extractLabel = ({
        UILabel *extractLabel = [[UILabel alloc] init];
        extractLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.extractBtn addSubview:extractLabel];
        extractLabel.font = [UIFont fontWithName:@"Billabong" size:20];
        extractLabel.text = @"Extract";
        extractLabel;
    });
    
    [self.extractLabel.centerXAnchor constraintEqualToAnchor:self.extractBtn.centerXAnchor].active = YES;
    [self.extractLabel.centerYAnchor constraintEqualToAnchor:self.extractBtn.centerYAnchor constant:3].active = YES;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(extract:)];
    [self.extractBtn addGestureRecognizer:tapGR];
    
}

- (LKAYoutubeLikeLoadingIndicatorView *)loadingIndicatorView {
    if (!_loadingIndicatorView) {
        _loadingIndicatorView = [[LKAYoutubeLikeLoadingIndicatorView alloc] init];
        _loadingIndicatorView.lineWidth = 2.0;
        _loadingIndicatorView.spinnerColors = @[[UIColor blackColor]];
        _loadingIndicatorView.alpha = 0.0;
        [self addSubview:_loadingIndicatorView];
    }
    return _loadingIndicatorView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    NSLog(@"%@", NSStringFromCGRect(self.extractBtn.frame));
    CGRect frame = CGRectMake(CGRectGetWidth(self.bounds) - INPUT_FIELD_CORNER_RADIUS * 2, 0, INPUT_FIELD_CORNER_RADIUS * 2, INPUT_FIELD_CORNER_RADIUS * 2);
    self.loadingIndicatorView.frame = frame;
}

- (void)squareButtonConstraint {
    self.widthBtnConstraint.active = NO;
    self.widthBtnConstraint = [self.extractBtn.widthAnchor constraintEqualToConstant:INPUT_FIELD_CORNER_RADIUS * 2];
     self.widthBtnConstraint.active = YES;
}

- (NSString *)postURLString {
    NSString *postString = self.inputTextField.text;
    ExtractURLType type;
    NSString *formatString = [CheckURLTool checkURLString:postString withExtractURLType:&type];
    _currentURLType = type;
    return formatString;
}


- (void)extract:(UITapGestureRecognizer *)recognizer {
    [self.inputTextField resignFirstResponder];
    if (!self.isExtracting) {
        
        NSString *extractString = self.postURLString;
        switch (self.currentURLType) {
            case ExtractInvalidURL:
                NSLog(@"ExtractInvalidURL :  %@", extractString);
                if ([self.delegate respondsToSelector:@selector(extractViewDidCallExtractWithInvalidURL:)]) {
                    [self.delegate extractViewDidCallExtractWithInvalidURL:self];
                }
                break;
            case ExtractValid:
                NSLog(@"ExtractValid :  %@", extractString);
                break;
            case ExtractEmptyURL:
                NSLog(@"ExtractEmptyURL :  %@", extractString);
                if ([self.delegate respondsToSelector:@selector(extractViewDidCallExtractWithEmptyURL:)]) {
                    [self.delegate extractViewDidCallExtractWithEmptyURL:self];
                }
                break;
        }
        
        if (self.currentURLType != ExtractValid) return;
        
        self.extracting = YES;
        
//        [self addSubview:self.loadingIndicatorView];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.extractLabel.alpha = 0.0;
        } completion:nil];
        
        [self squareButtonConstraint];
        [UIView animateWithDuration:1.0 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutIfNeeded];
            self.extractBtn.backgroundColor = COLOR_BACKGROUND;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.extractBtn.alpha = 0.0;
                self.loadingIndicatorView.alpha = 1.0;
            } completion:^(BOOL finished) {

                [self.loadingIndicatorView startAnimating];
                if ([self.delegate respondsToSelector:@selector(extractViewDidCallExtract:withValidURL:)]) {
                    [self.delegate extractViewDidCallExtract:self withValidURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?__a=1", extractString]]];
                }
            }];
        }];
        
    }
}

/**
 set up text field
 */
- (void)setupTextField {
    self.inputTextField = ({
        LKATextField *textField = [[LKATextField alloc] init];
        [self addSubview:textField];
        textField;
    });
    
    [self.inputTextField.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0].active = YES;
    [self.inputTextField.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
//    [self.inputTextField.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.75].active = YES;
    [self.inputTextField.heightAnchor constraintEqualToConstant:INPUT_FIELD_CORNER_RADIUS * 2].active = YES;
    [self.inputTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.inputTextField setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    NSMutableParagraphStyle *centeredParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    centeredParagraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributeDict = @{
                                    NSFontAttributeName: [UIFont fontWithName:@"Billabong" size:20],
                                    NSForegroundColorAttributeName: [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.00],
                                    NSParagraphStyleAttributeName: centeredParagraphStyle,
                                    NSBaselineOffsetAttributeName: @-0.5
                                    };
//
    NSMutableParagraphStyle *defaultParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    defaultParagraphStyle.alignment = NSTextAlignmentLeft;
    defaultParagraphStyle.lineBreakMode = NSLineBreakByTruncatingHead;
//    defaultParagraphStyle.minimumLineHeight = INPUT_FIELD_CORNER_RADIUS;
    self.inputTextField.defaultTextAttributes = @{
                                                  NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:20],
                                                  NSForegroundColorAttributeName: [UIColor blackColor]
//                                                  NSParagraphStyleAttributeName: defaultParagraphStyle
                                                  };
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"Paste URL Here" attributes:attributeDict];
    self.inputTextField.attributedPlaceholder = string;
    self.inputTextField.text = @"https://instagram.com/p/BYclk7xAytx/";
}

- (void)cancellLoading {
    
    if (!self.extracting) return;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.loadingIndicatorView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loadingIndicatorView stopAnimating];
    }];
    
    [UIView animateWithDuration:1 delay:0.2 options:kNilOptions animations:^{
        self.extractBtn.alpha = 1;
        self.extractBtn.backgroundColor = [UIColor whiteColor];
    } completion:^(BOOL finished) {
        [self originButtonConstraint];
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self layoutIfNeeded];
            self.extractLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.extracting = NO;
        }];
    }];
    

}

- (void)originButtonConstraint {
    self.widthBtnConstraint.active = NO;
    self.widthBtnConstraint = [self.extractBtn.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.2];
    self.widthBtnConstraint.active = YES;
}

@end
