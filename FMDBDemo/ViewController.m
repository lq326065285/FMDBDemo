//
//  ViewController.m
//  FMDBDemo
//
//  Created by 李强 on 14-12-22.
//  Copyright (c) 2014年 思埠集团. All rights reserved.
//

#import "ViewController.h"

#import "FMDBManager.h"

@interface ViewController ()
{
    FMDBManager * _manager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
#pragma mark - 将http://www.baidu.com作为复制成功的信息
    UIPasteboard * pb = [UIPasteboard generalPasteboard];
    
    pb.string = @"http://www.baidu.com";
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _manager = [FMDBManager shareDBManager];
    [_manager createTableWithName:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITEXTFEILD DELEGATE
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textAge resignFirstResponder];
    [_textID resignFirstResponder];
    [_textName resignFirstResponder];
}
#pragma mark - BUTTON ACTION

- (IBAction)clickAddData:(id)sender {
    if (![_textID.text isEqualToString:@""] && ![_textAge.text isEqualToString:@""] && ![_textName.text isEqualToString:@""]) {
        [_manager insertDataToTable:_textID.text age:_textAge.text name:_textName.text];
    }
}

- (IBAction)clickDeleteData:(id)sender {
    if (![_textName.text isEqualToString:@""]) {
        [_manager deleteDataFromTable:_textName.text];
    }
}

- (IBAction)clickChangeData:(id)sender {
    if (![_textID.text isEqualToString:@""] && ![_textAge.text isEqualToString:@""] && ![_textName.text isEqualToString:@""]) {
        [_manager updateDataFromTable:_textID.text age:_textAge.text name:_textName.text];
    }
}

- (IBAction)clickSelectData:(id)sender {
    NSArray * array = [_manager selectDataFromTable:_textName.text];
    NSLog(@"%@",array);
}
@end
