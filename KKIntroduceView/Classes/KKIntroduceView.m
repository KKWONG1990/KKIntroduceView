//
//  KKPhotoIntroduceView.m
//  MyPratice
//
//  Created by BYMac on 2022/2/17.
//

#import "KKIntroduceView.h"
#import "KKIntroduceItem.h"
@interface KKIntroduceView()<UIScrollViewDelegate>
@property (nonatomic) NSUInteger idx;
@property (nonatomic, strong) UIView * parentView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSArray<KKIntroduceItem *> * items;
@property (nonatomic, strong) UIImageView * backgroundImageView;
@property (nonatomic, strong) UIImageView * showBackgroundImageView;
@property (nonatomic, strong) NSArray<UIImage *> * backgroundImages;
@property (nonatomic, strong) NSDictionary<NSNumber * , UIImageView *> * imageViews;
@property (nonatomic, strong) NSDictionary<NSNumber * , UILabel *> * titleLabels;
@property (nonatomic, strong) NSDictionary<NSNumber * , UILabel *> * descLabels;
@property (nonatomic, strong) NSDictionary<NSNumber *, UIButton *> * buttons;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) CABasicAnimation * animation;
@end

NSString * const ContentOffsetKeyPath = @"contentOffset";


@implementation KKIntroduceView
{
    CGPoint _currentContentOffset;
}

- (instancetype)initWithItems:(NSArray<KKIntroduceItem *> *)items {
    return [self initWithFrame:CGRectZero items:items];
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<KKIntroduceItem *> *)items {
    self = [super initWithFrame:frame];
    if (self) {
        _items = items;
        _showPageControl = YES;
    }
    return self;
}

- (void)initializeDatasouce {
    
    NSMutableArray * backgroundImages = [NSMutableArray array];
    NSMutableDictionary * imageViews = [NSMutableDictionary dictionary];
    NSMutableDictionary * titleLabels = [NSMutableDictionary dictionary];
    NSMutableDictionary * descLabels = [NSMutableDictionary dictionary];
    NSMutableDictionary * buttons = [NSMutableDictionary dictionary];
    
    [self.items enumerateObjectsUsingBlock:^(KKIntroduceItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (item) {
            
            if (item.bgImage) {
                [backgroundImages addObject:item.bgImage];
            }
            
            UIImageView * imageView = [self createImageViewWithItem:item];
            if (imageView) {
                [imageViews addEntriesFromDictionary:@{@(idx) : imageView}];
            }
            
            UILabel * titleLabel = [self createTitleLabelViewWithItem:item idx:idx];
            if (titleLabel) {
                [titleLabels addEntriesFromDictionary:@{@(idx) : titleLabel}];
            }
            
            UILabel * descLabel =  [self createDetailLabelViewWithItem:item idx:idx];
            if (descLabel) {
                [descLabels addEntriesFromDictionary:@{@(idx) : descLabel}];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(introduceView:buttonForPageInScrollViewWithIdx:)]) {
                UIButton * button = [self.delegate introduceView:self buttonForPageInScrollViewWithIdx:idx];
                if (button) {
                    [buttons addEntriesFromDictionary:@{@(idx) : button}];
                }
            }
        }
    }];

    self.backgroundImages = (NSArray *)backgroundImages;
    self.imageViews = (NSDictionary *)imageViews;
    self.titleLabels = (NSDictionary *)titleLabels;
    self.descLabels = (NSDictionary *)descLabels;
    self.buttons = (NSDictionary *)buttons;
    
}

- (void)setupUI {
    
    UIImageView * backgroundImageView = [[UIImageView alloc] init];
    UIImageView * showBackgroundImageView = [[UIImageView alloc] init];
    [self addSubview:backgroundImageView];
    [self addSubview:showBackgroundImageView];
    self.backgroundImageView = backgroundImageView;
    self.showBackgroundImageView = showBackgroundImageView;
    
    if (self.backgroundImages.count) {
        self.showBackgroundImageView.image = self.backgroundImages.firstObject;
    }
    
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = UIColor.clearColor;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;

    [self.imageViews enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIImageView * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.scrollView addSubview:obj];
    }];
    
    [self.titleLabels enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UILabel * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.scrollView addSubview:obj];
    }];
    
    [self.descLabels enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UILabel * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.scrollView addSubview:obj];
    }];
    
    [self.buttons enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIButton * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.scrollView addSubview:obj];
    }];
    
    if (self.isShowPageControl) {
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.numberOfPages = self.items.count;
        self.pageControl.currentPage = self.idx;
        [self addSubview:self.pageControl];
        
    }
    
    if (self.isShowActionExample) {
        scrollView.userInteractionEnabled = !self.isShowActionExample;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupPageControlFrame];
    [self setupBackgroundFrame];
    [self setupScrollViewFrame];
    [self setupImageViewItemFrame];
    [self setupTitleFrame];
    [self setupDetailFrame];
    [self setupButtonFrame];
}


- (void)willAppearPageWithIdx:(NSUInteger)idx {
    if (self.delegate && [self.delegate respondsToSelector:@selector(introduceView:willAppearPageWithIdx:)]) {
        [self.delegate introduceView:self willAppearPageWithIdx:idx];
    }
}

- (void)didAppearPageWithIdx:(NSUInteger)idx {
    if (self.delegate && [self.delegate respondsToSelector:@selector(introduceView:didAppearPageWithIdx:)]) {
        [self.delegate introduceView:self didAppearPageWithIdx:idx];
    }
}

- (void)willDisappearPageWithIdx:(NSUInteger)idx {
    if (self.delegate && [self.delegate respondsToSelector:@selector(introduceView:willDisappearPageWithIdx:)]) {
        [self.delegate introduceView:self willDisappearPageWithIdx:idx];
    }
}

- (void)show {
    [self showInView:UIApplication.sharedApplication.delegate.window];
}

- (void)hide {
    [self removeObservers];
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)view {
    
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        self.frame = view.bounds;
    }
    
    [self initializeDatasouce];
    [self setupUI];
    [self addObservers];
    [self willAppearPageWithIdx:self.idx];
    [view addSubview:self];
    [self didAppearPageWithIdx:self.idx];
    self.parentView = view;
    [self showUserActionExample];
    
}

- (void)showUserActionExample {
    
    if (self.isShowActionExample) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^{
                [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame) / 8, 0) animated:NO];
            }];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^{
                [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            }];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^{
                [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame) / 8, 0) animated:NO];
            }];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^{
                [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            } completion:^(BOOL finished) {
                self.showActionExample = NO;
                self.scrollView.userInteractionEnabled = !self.isShowActionExample;
            }];
        });
    }
}

- (void)addObservers {
    [self.scrollView addObserver:self forKeyPath:ContentOffsetKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    [self.scrollView removeObserver:self forKeyPath:ContentOffsetKeyPath context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:ContentOffsetKeyPath]) {
        
        CGPoint newContentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        
        //如果相等，则没有变化不必更新
        if (_currentContentOffset.x == newContentOffset.x) {
            return;
        }
        
        //如果当前偏移量刚好是某一页的偏移量, 则代表到了新的一页
        if (newContentOffset.x == self.idx * CGRectGetWidth(self.scrollView.frame)) {
            [self didAppearPageWithIdx:self.idx];
            [self switchShowBackgroundImageWhenScrollViewDidEndDeceleratingWithIdx:self.idx];
            _currentContentOffset = newContentOffset;
            if (self.pageControl) {
                self.pageControl.currentPage = self.idx;
            }
        }
    }
    
}

- (void)updateBackgroundImageWithNextPage:(BOOL)nextPage {
    if (self.backgroundImages.count <= 1) return;
    if (self.idx >= self.backgroundImages.count - 1) return;
    
    CGFloat alpha = 0.0;
    if (nextPage) {
        alpha = (self.scrollView.contentOffset.x - _currentContentOffset.x) / CGRectGetWidth(self.scrollView.frame);
        self.backgroundImageView.image = [self.backgroundImages objectAtIndex:self.idx + 1];
    } else {
        alpha = (_currentContentOffset.x - self.scrollView.contentOffset.x) / CGRectGetWidth(self.scrollView.frame);
        self.backgroundImageView.image = [self.backgroundImages objectAtIndex:self.idx];
    }
    self.backgroundImageView.alpha = alpha;
    self.showBackgroundImageView.alpha = 1 - alpha;
}

- (void)updatePageStateWidhNextPage:(BOOL)nextPage {
    if (nextPage) {
        [self willAppearPageWithIdx:self.idx + 1];
        [self willDisappearPageWithIdx:self.idx];
    } else {
        [self willAppearPageWithIdx:self.idx];
        [self willDisappearPageWithIdx:self.idx + 1];
    }
}

- (void)switchShowBackgroundImageWhenScrollViewDidEndDeceleratingWithIdx:(NSUInteger)idx {
    if (self.backgroundImages.count <= 1) return;
    self.showBackgroundImageView.image = [self.backgroundImages objectAtIndex:idx];
    self.backgroundImageView.alpha = 0.0;
    self.showBackgroundImageView.alpha = 1.0;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x <= 0) return;
    if (scrollView.contentOffset.x >= scrollView.contentSize.width) return;
    if (scrollView.contentOffset.x > _currentContentOffset.x) {
        //向左滑,下一页
        [self updateBackgroundImageWithNextPage:YES];
        [self updatePageStateWidhNextPage:YES];
    } else {
        //向右滑，上一页
        [self updateBackgroundImageWithNextPage:NO];
        [self updatePageStateWidhNextPage:NO];
    }
    NSUInteger idx = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.idx = idx;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x <= 0) return;
    if (scrollView.contentOffset.x >= scrollView.contentSize.width) return;
    _currentContentOffset = scrollView.contentOffset;
}

#pragma mark - 创建子视图
- (nullable UIImageView *)createImageViewWithItem:(KKIntroduceItem *)item {
    if (!item.image) return nil;
    UIImageView * imageView = [[UIImageView alloc] initWithImage:item.image];
    return imageView;
}

- (nullable UILabel *)createTitleLabelViewWithItem:(KKIntroduceItem *)item idx:(NSUInteger)idx {
    if (!item.title && !item.titleAttributedString) return nil;
    UILabel * label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    if (item.titleAttributedString) {
        label.attributedText = item.titleAttributedString;
    } else {
        label.text = item.title;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(introduceView:customTitleLabelStyle:idx:)]) {
        [self.delegate introduceView:self customTitleLabelStyle:label idx:idx];
    }
    return label;
}

- (UILabel *)createDetailLabelViewWithItem:(KKIntroduceItem *)item idx:(NSUInteger)idx {
    if (!item.desc && !item.descAttributedString) return nil;
    UILabel * label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    if (item.descAttributedString) {
        label.attributedText = item.descAttributedString;
    } else {
        label.text = item.desc;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(introduceView:customDescLabelStyle:idx:)]) {
        [self.delegate introduceView:self customDescLabelStyle:label idx:idx];
    }
    return label;
}

#pragma mark - 设置视图位置大小
- (void)setupBackgroundFrame {
    self.backgroundImageView.frame = self.bounds;
    self.showBackgroundImageView.frame = self.bounds;
}

- (void)setupScrollViewFrame {
    self.scrollView.frame = self.bounds;
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.items.count, 0)];
}

- (void)setupImageViewItemFrame {
    [self.imageViews enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIImageView * _Nonnull obj, BOOL * _Nonnull stop) {
        NSUInteger idx = [key integerValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(introduceView:setRectForImageView:idx:)]) {
            obj.frame =  [self.delegate introduceView:self setRectForImageView:obj idx:idx];
        } else {
            obj.frame = CGRectMake(self.bounds.size.width * idx, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        }
    }];
}

- (void)setupTitleFrame {
    [self.titleLabels enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UILabel * _Nonnull obj, BOOL * _Nonnull stop) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(introduceView:setRectForTitleLabel:idx:)]) {
            obj.frame = [self.delegate introduceView:self setRectForTitleLabel:obj idx:[key integerValue]];
        }
    }];
}

- (void)setupDetailFrame {
    [self.descLabels enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UILabel * _Nonnull obj, BOOL * _Nonnull stop) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(introduceView:setRectForDescLabel:idx:)]) {
            obj.frame = [self.delegate introduceView:self setRectForDescLabel:obj idx:[key integerValue]];
        }
    }];
}

- (void)setupButtonFrame {
    [self.buttons enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIButton * _Nonnull obj, BOOL * _Nonnull stop) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(introduceView:setRectForButtonWithIdx:)]) {
            obj.frame = [self.delegate introduceView:self setRectForButtonWithIdx:[key integerValue]];
        }
    }];
}

- (void)setupPageControlFrame {
    if (self.isShowPageControl) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(setRectForPageControlInIntroduceView:)]) {
            self.pageControl.frame = [self.delegate setRectForPageControlInIntroduceView:self];
        }
    }
}

@end
