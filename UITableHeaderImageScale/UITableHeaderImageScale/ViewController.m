//
//  ViewController.m
//  UITableHeaderImageScale
//
//  Created by oucaizi on 15/11/24.
//  Copyright © 2015年 oucaizi. All rights reserved.
//

#import "ViewController.h"

static NSString * Identifier =@"content";

const CGFloat image_h  =260;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.ptableView];
    [self.ptableView addSubview:self.hImageView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    return cell;
}

#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y=scrollView.contentOffset.y;
    if (y<image_h) {
        CGRect frame = self.hImageView.frame;
        frame.origin.y = y;
        frame.size.height =  -y;
        self.hImageView.frame = frame;
    }
}


#pragma mark getter

-(UITableView*)ptableView{
    if (!_ptableView) {
        _ptableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_ptableView setDataSource:self];
        [_ptableView setDelegate:self];
        [_ptableView setContentInset:UIEdgeInsetsMake(image_h, 0, 0, 0)];
    }
    return _ptableView;
}

-(UIImageView*)hImageView{
    if (!_hImageView) {
        _hImageView =[[UIImageView alloc] init];
        [_hImageView setImage:[UIImage imageNamed:@"car"]];
        [_hImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_hImageView setFrame:CGRectMake(0, -image_h, CGRectGetWidth(self.view.frame), image_h)];
    }
    return _hImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
