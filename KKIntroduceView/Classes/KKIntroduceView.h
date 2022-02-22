//
//  KKPhotoIntroduceView.h
//  MyPratice
//
//  Created by BYMac on 2022/2/17.
//

#import <UIKit/UIKit.h>
@class KKIntroduceItem;
@class KKIntroduceView;
NS_ASSUME_NONNULL_BEGIN

@protocol KKIntroduceViewDelegagte <NSObject>

@optional;

/// 页面即将显示
/// @param introduceView KKIntroduceView
/// @param idx 即将显示页面的下标
- (void)introduceView:(KKIntroduceView *)introduceView willAppearPageWithIdx:(NSUInteger)idx;

/// 页面显示完成
/// @param introduceView KKIntroduceView
/// @param idx 显示页面的下标
- (void)introduceView:(KKIntroduceView *)introduceView didAppearPageWithIdx:(NSUInteger)idx;

/// 页面即将消失
/// @param introduceView KKIntroduceView
/// @param idx 消失页面的下标
- (void)introduceView:(KKIntroduceView *)introduceView willDisappearPageWithIdx:(NSUInteger)idx;

/// 自定义标题标签样式
/// @param introduceView KKIntroduceView
/// @param label 标题标签
/// @param idx 下标
- (void)introduceView:(KKIntroduceView *)introduceView customTitleLabelStyle:(UILabel *)label idx:(NSUInteger)idx;

/// 自定义描述标签样式
/// @param introduceView KKIntroduceView
/// @param label 描述标签
/// @param idx 下标
- (void)introduceView:(KKIntroduceView *)introduceView customDescLabelStyle:(UILabel *)label idx:(NSUInteger)idx;

/// 为页面创建按钮
/// @param introduceView KKIntroduceView
/// @param idx 下标
- (nullable UIButton *)introduceView:(KKIntroduceView *)introduceView buttonForPageInScrollViewWithIdx:(NSUInteger)idx;

/// 设置页面控制器的位置大小
/// @param introduceView KKIntroduceView
- (CGRect)setRectForPageControlInIntroduceView:(KKIntroduceView *)introduceView;

/// 设置photoImte的frame
/// @param index 下标
/// @param introduceView KKIntroduceView
- (CGRect)introduceView:(KKIntroduceView *)introduceView setRectForImageView:(UIImageView *)imageView index:(NSUInteger)index;

/// 设置标题标签的位置大小
/// @param introduceView KKIntroduceView
/// @param label 标题标签
/// @param idx 下标
- (CGRect)introduceView:(KKIntroduceView *)introduceView setRectForTitleLabel:(UILabel *)label idx:(NSUInteger)idx;

/// 设置描述标签位置大小
/// @param introduceView KKIntroduceView
/// @param label 描述标签
/// @param idx 下标
- (CGRect)introduceView:(KKIntroduceView *)introduceView setRectForDescLabel:(UILabel *)label idx:(NSUInteger)idx;

/// 设置按钮位置大小
/// @param introduceView KKIntroduceView
/// @param idx 下标
- (CGRect)introduceView:(KKIntroduceView *)introduceView setRectForButtonWithIdx:(NSUInteger)idx;

@end


@interface KKIntroduceView : UIView

/// 初始化方法
/// @param items KKPhotoItem数组
- (instancetype)initWithItems:(NSArray<KKIntroduceItem *> *)items;

/// 初始化方法
/// @param frame CGRect
/// @param items KKPhotoItem数组
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<KKIntroduceItem *> *)items;

/// 父视图
@property (nonatomic, strong, readonly) UIView * parentView;

/// 装载PhotoItem的滚动视图
@property (nonatomic, strong, readonly) UIScrollView * scrollView;

/// 下一张的背景图视图 - 不显示
@property (nonatomic, strong, readonly) UIImageView * backgroundImageView;

/// 当前背景图视图 - 显示
@property (nonatomic, strong, readonly) UIImageView * showBackgroundImageView;

/// 数据源
@property (nonatomic, strong, readonly) NSArray<KKIntroduceItem *> * items;

/// 背景图片源
@property (nonatomic, strong, readonly) NSArray<UIImage *> * backgroundImages;

/// 页面图片视图源
@property (nonatomic, strong, readonly) NSDictionary<NSNumber * , UIImageView *> * imageViews;

/// 页面标题标签源
@property (nonatomic, strong, readonly) NSDictionary<NSNumber * , UILabel *> * titleLabels;

/// 页面描述标签源
@property (nonatomic, strong, readonly) NSDictionary<NSNumber * , UILabel *> * descLabels;

/// 页面按钮源
@property (nonatomic, strong, readonly) NSDictionary<NSNumber * , UIButton *> * buttons;

/// 代理
@property (nonatomic, weak) id<KKIntroduceViewDelegagte> delegate;

/// 页面控制器
@property (nonatomic, strong, readonly) UIPageControl * pageControl;

/// 是否显示页面控制器 - 默认YES
@property (nonatomic, assign, getter=isShowPageControl) BOOL showPageControl;

/// 当前下标
@property (nonatomic, readonly) NSUInteger idx;

/// 展示window
- (void)show;

/// 隐藏并从父视图移除
- (void)hide;

/// 展示到指定的视图
/// @param view 视图
- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
