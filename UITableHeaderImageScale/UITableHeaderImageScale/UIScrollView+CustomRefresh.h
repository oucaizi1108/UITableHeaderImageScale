//
//  UIScrollView+CustomRefresh.h
//  CustomRefresh
//
//  Created by oucaizi on 15/11/24.
//  Copyright © 2015年 oucaizi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomRefreshView;



@interface UIScrollView (CustomRefresh)

@property(nonatomic,strong,readonly) CustomRefreshView *refreshView;

@property(nonatomic,assign) BOOL showPullToRefresh;

-(void)addHeaderImageHandel:(UIImage*)image;

@end


@interface CustomRefreshView : UIView

/**
 *  kvo监听当前视图是否处于监听状态
 */
@property(nonatomic,assign) BOOL isObserving;

@property(nonatomic,strong) UIImageView *hImageView;

@property(nonatomic) UIImage *pic_image;

@end