//
//  UIScrollView+CustomRefresh.h
//  CustomRefresh
//
//  Created by oucaizi on 15/11/24.
//  Copyright © 2015年 oucaizi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomRefreshView;


@interface UIScrollView (ShowHeadImage)

@property(nonatomic,strong,readonly) CustomRefreshView *refreshView;

@property(nonatomic,assign) BOOL showHeadImage;

-(void)addHeaderImage:(UIImage*)image;

@end


@interface CustomRefreshView : UIView

@property(nonatomic,strong,readonly) UIImageView *hImageView;

@end