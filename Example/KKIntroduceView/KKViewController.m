//
//  KKViewController.m
//  KKIntroduceView
//
//  Created by kkwong90@163.com on 02/22/2022.
//  Copyright (c) 2022 kkwong90@163.com. All rights reserved.
//

#import "KKViewController.h"
#import <KKIntroduceView.h>
#import <KKIntroduceItem.h>
@interface KKViewController ()<KKIntroduceViewDelegagte>
@property (nonatomic, strong) KKIntroduceView * introduceView;
@end

@implementation KKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    KKIntroduceItem * item0 = [[KKIntroduceItem alloc] init];
    item0.bgImage = [UIImage imageNamed:@"bg1"];
    item0.image = [UIImage imageNamed:@"title1"];
    item0.title = @"亲情家庭";
    item0.desc = @"邀请进入家庭，健康守护家人";

    KKIntroduceItem * item1 = [[KKIntroduceItem alloc] init];
    item1.bgImage = [UIImage imageNamed:@"bg2"];
    item1.image = [UIImage imageNamed:@"title2"];
    item1.title = @"卫星定位";
    item1.descAttributedString = [[NSAttributedString alloc] initWithString:@"无论老人身在何方，完全掌握,无论老人身在何方，完全掌握,无论老人身在何方，完全掌握,无论老人身在何方，完全掌握" attributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:20],
        NSForegroundColorAttributeName : UIColor.redColor,
        NSParagraphStyleAttributeName : [self style],
    }];

    KKIntroduceItem * item2 = [[KKIntroduceItem alloc] init];
    item2.bgImage = [UIImage imageNamed:@"bg3"];
    item2.image = [UIImage imageNamed:@"title3"];
    item2.title = @"健康咨询";
    item2.desc = @"花五分钟阅读，做健康达人,花五分钟阅读，做健康达人,花五分钟阅读，做健康达人,花五分钟阅读，做健康达人";

    KKIntroduceItem * item3 = [[KKIntroduceItem alloc] init];
    item3.bgImage = [UIImage imageNamed:@"bg4"];
    item3.image = [UIImage imageNamed:@"title4"];
    item3.title = @"健康数据";
    item3.desc = @"随时掌握家人健康情况";

    self.introduceView = [[KKIntroduceView alloc] initWithFrame:self.view.bounds items:@[item0, item1, item2, item3]];
    self.introduceView.delegate = self;
    [self.introduceView showInView:self.view];
}

- (NSParagraphStyle *)style {
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    return style;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - KKPhotoIntroduceViewDelegagte
- (void)introduceView:(KKIntroduceView *)introduceView willAppearPageWithIdx:(NSUInteger)idx {
    NSLog(@"willAppearPageWithIdx = %ld",(long)idx);
}

- (void)introduceView:(KKIntroduceView *)introduceView didAppearPageWithIdx:(NSUInteger)idx {
    NSLog(@"didAppearPageWithIdx = %ld",(long)idx);

}

- (void)introduceView:(KKIntroduceView *)introduceView willDisappearPageWithIdx:(NSUInteger)idx {
    NSLog(@"willDisappearPageWithIdx = %ld",(long)idx);
}

- (UIButton *)introduceView:(KKIntroduceView *)introduceView buttonForPageInScrollViewWithIdx:(NSUInteger)idx {
    if (idx == 3) {
        UIButton * btn = [[UIButton alloc] init];
        [btn setTitle:@"开启新版之旅" forState:UIControlStateNormal];
        btn.backgroundColor = UIColor.brownColor;
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.layer.cornerRadius = 25;
        return btn;
    }
    return nil;
}

- (CGRect)introduceView:(KKIntroduceView *)introduceView setRectForButtonWithIdx:(NSUInteger)idx {
    if (idx == 3) {
        return CGRectMake(idx * CGRectGetWidth(introduceView.frame) + 50, CGRectGetHeight(introduceView.frame) - 80, CGRectGetWidth(introduceView.frame) - 100, 50);
    }
    return CGRectZero;
}

- (CGRect)setRectForPageControlInIntroduceView:(KKIntroduceView *)introduceView {
    return CGRectMake(15, CGRectGetHeight(introduceView.frame) - 130, CGRectGetWidth(introduceView.frame), 20);
}

- (void)introduceView:(KKIntroduceView *)introduceView customTitleLabelStyle:(UILabel *)label idx:(NSUInteger)idx {
    label.textColor = UIColor.whiteColor;
    label.font = [UIFont systemFontOfSize:30];
}

- (CGRect)introduceView:(KKIntroduceView *)introduceView setRectForTitleLabel:(UILabel *)label idx:(NSUInteger)idx {
    CGSize size = [label sizeThatFits:CGSizeMake(CGRectGetWidth(introduceView.scrollView.frame) - 30, MAXFLOAT)];
    return CGRectMake(15 + CGRectGetWidth(introduceView.scrollView.frame) * idx, CGRectGetHeight(introduceView.frame) - 250, CGRectGetWidth(introduceView.scrollView.frame) - 30, size.height);
}

- (void)introduceView:(KKIntroduceView *)introduceView customDescLabelStyle:(UILabel *)label idx:(NSUInteger)idx {
    label.textColor = UIColor.whiteColor;
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
}

- (CGRect)introduceView:(KKIntroduceView *)introduceView setRectForDescLabel:(UILabel *)label idx:(NSUInteger)idx {
    CGSize size = [label sizeThatFits:CGSizeMake(CGRectGetWidth(introduceView.scrollView.frame) - 30, MAXFLOAT)];
    return CGRectMake(15 + CGRectGetWidth(introduceView.scrollView.frame) * idx, CGRectGetHeight(introduceView.scrollView.frame) - 200, CGRectGetWidth(introduceView.scrollView.frame) - 30, size.height);
}

- (CGRect)introduceView:(KKIntroduceView *)introduceView setRectForImageView:(UIImageView *)imageView idx:(NSUInteger)idx {
    CGFloat x = CGRectGetWidth(introduceView.scrollView.frame) * idx + (CGRectGetWidth(introduceView.scrollView.frame) / 2 - imageView.image.size.width / 2);
    return CGRectMake(x, 80, imageView.image.size.width, imageView.image.size.height);
}



@end
