//
//  UIScrollView+CustomRefresh.m
//  CustomRefresh
//
//  Created by oucaizi on 15/11/24.
//  Copyright © 2015年 oucaizi. All rights reserved.
//

#import "UIScrollView+ShowHeadImage.h"
#import <objc/runtime.h>

@interface CustomRefreshView ()

/**
 *  kvo监听当前视图是否处于监听状态
 */
@property(nonatomic,assign) BOOL isObserving;

@property(nonatomic) UIImage *picImage;

@property(nonatomic,strong) UIImageView *iconImage;

@property(nonatomic,assign) CGFloat OriginEdgeInsetTop;

@property(nonatomic) UIImage *iconPic;

@property(nonatomic,weak) UIScrollView *scrollView;

@end


static CGFloat const RefreshViewHeight = 260;
static const char *refreshViewKey ;


@implementation UIScrollView (ShowHeadImage)

@dynamic showHeadImage,refreshView;

-(void)addHeaderImage:(UIImage*)image icon:(UIImage *)icon{
    
    if (!self.refreshView) {
        
        CGFloat originEdgeInsetTop=self.contentInset.top;
        
        [self setContentInset:UIEdgeInsetsMake(RefreshViewHeight+originEdgeInsetTop, 0, 0, 0)];
        CustomRefreshView *view=[[CustomRefreshView alloc] initWithFrame:CGRectMake(0, -RefreshViewHeight-originEdgeInsetTop, CGRectGetWidth(self.bounds), RefreshViewHeight)];
        view.picImage=image;
        view.iconPic=icon;
        view.scrollView=self;
        view.OriginEdgeInsetTop=originEdgeInsetTop;
        self.refreshView=view;
        [self addSubview:self.refreshView];
        self.showHeadImage = YES;
    }
}


#pragma mark setter/getter

//类别中增加方法用runtime重新合成属性
-(void)setRefreshView:(CustomRefreshView *)refreshView{
     objc_setAssociatedObject(self, &refreshViewKey, refreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CustomRefreshView*)refreshView{
  return   objc_getAssociatedObject(self, &refreshViewKey);
}


-(void)setShowHeadImage:(BOOL)showHeadImage{
    if (showHeadImage) {
        //self.refreshView 作为kvo观察者
        if (!self.refreshView.isObserving) {
            [self addObserver:self.refreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            self.refreshView.isObserving=YES;
            
        }
    }else{
        
        if (!self.refreshView.isObserving) {
            [self removeObserver:self.refreshView forKeyPath:@"contentOffset"];
            self.refreshView.isObserving=NO;
        }
    }
}




-(void)dealloc
{
    [self removeObserver:self.refreshView forKeyPath:@"contentOffset"];
}

@end


static const CGFloat ICON_W_B =70;
static const CGFloat ICON_W_S =40;

@implementation CustomRefreshView

@synthesize hImageView=_hImageView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.hImageView setFrame:self.bounds];
        [self addSubview:self.hImageView];
        
        [self.iconImage setFrame:CGRectMake(0, 0, ICON_W_B, ICON_W_B)];
        self.iconImage.center=self.hImageView.center;
        self.iconImage.layer.cornerRadius=ICON_W_B/2;
        [self addSubview:self.iconImage];
    }
    return self;
}

-(void)setPicImage:(UIImage *)picImage{
    _picImage=picImage;
    [self.hImageView setImage:_picImage];
}

-(void)setIconPic:(UIImage *)iconPic{
    _iconPic=iconPic;
    [self.iconImage setImage:_iconPic];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (self.superview&&newSuperview==nil) {
        UIScrollView *scrollView=(UIScrollView *)self.superview;
        if (scrollView.showHeadImage) {
            if (self.isObserving) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    CGFloat y=contentOffset.y;

    if (y<-RefreshViewHeight) {
    
        CGRect frame = self.frame;
        frame.origin.y = y;
        frame.size.height =-y;
        self.frame = frame;
        [self.hImageView setFrame:self.bounds];
        
        [self.iconImage setFrame:CGRectMake(0, 0, ICON_W_B,ICON_W_B)];
        self.iconImage.center=CGPointMake(self.hImageView.center.x, RefreshViewHeight/2);
        self.iconImage.layer.cornerRadius=CGRectGetHeight(self.iconImage.frame)/2;
        self.scrollView.contentInset=UIEdgeInsetsMake(RefreshViewHeight, 0, 0, 0);
        
        
    }else if(y>-RefreshViewHeight){
    
        if (y<=-64) {
            
            CGFloat rate=(fabs(contentOffset.y)-64)/(RefreshViewHeight-64);
            if (rate>=0) {
                [self.scrollView setBounces:YES];
                
                CGRect frame = self.frame;
                frame.origin.y = contentOffset.y;
                frame.size.height =-contentOffset.y;
                self.frame = frame;
                [self.hImageView setFrame:self.bounds];
                self.scrollView.contentInset=UIEdgeInsetsMake(CGRectGetHeight(self.frame), 0, 0, 0);
                
                CGFloat width=ICON_W_S+(ICON_W_B-ICON_W_S)*rate;
                [self.iconImage setFrame:CGRectMake(0, 0, width,width)];
                self.iconImage.center=CGPointMake(self.hImageView.center.x, 44+(RefreshViewHeight/2-44)*rate);
                self.iconImage.layer.cornerRadius=CGRectGetHeight(self.iconImage.frame)/2;
            }
            [self.scrollView setBounces:YES];
        }
        else{
            [self.scrollView setBounces:NO];
        }
 
    }

    
}

#pragma mark setter

-(UIImageView*)hImageView{
    if (!_hImageView) {
        _hImageView =[[UIImageView alloc] init];
        [_hImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_hImageView setClipsToBounds:YES];
    }
    return _hImageView;
}

-(UIImageView*)iconImage{
    if (!_iconImage) {
        _iconImage=[[UIImageView alloc] init];
        _iconImage.layer.shouldRasterize=YES;
        _iconImage.layer.rasterizationScale=[[UIScreen mainScreen] scale];
        _iconImage.layer.masksToBounds=YES;
        [_iconImage setBackgroundColor:[UIColor whiteColor]];
        [_iconImage.layer setBorderWidth:2];
        [_iconImage.layer setBorderColor:[[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1] CGColor]];
        
    }
    return _iconImage;
}

@end