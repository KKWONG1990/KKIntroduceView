//
//  KKPhotoItem.h
//  MyPratice
//
//  Created by BYMac on 2022/2/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface KKIntroduceItem : NSObject

/// 背景图片
@property (nonatomic, strong) UIImage * bgImage;

/// 图片
@property (nonatomic, strong) UIImage * image;

/// 标题
@property (nonatomic, copy) NSString * title;

/// 描述
@property (nonatomic, copy) NSString * desc;

/// 富文本标题
@property (nonatomic, strong) NSAttributedString * titleAttributedString;

/// 富文本描述
@property (nonatomic, strong) NSAttributedString * descAttributedString;

@end

NS_ASSUME_NONNULL_END
