//
//  ViewController.m
//  UITableHeaderImageScale
//
//  Created by oucaizi on 15/11/24.
//  Copyright © 2015年 oucaizi. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+ShowHeadImage.h"
#import "Person.h"
static NSString * Identifier =@"content";


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.ptableView];

    Person * p = [[Person alloc] init];
    [p setValue:@"ss" forKey:@"name"];
    NSLog(@"==%@",[p valueForKey:@"name"]);
    
    [self.ptableView addHeaderImage:[UIImage imageNamed:@"car"] icon:[UIImage imageNamed:@"background"]];
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
    if (indexPath.row==0) {
        cell.textLabel.text=@"primy";
   
    }
    return cell;
}




#pragma mark getter

-(UITableView*)ptableView{
    if (!_ptableView) {
        _ptableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_ptableView setDataSource:self];
        [_ptableView setDelegate:self];
    }
    return _ptableView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
