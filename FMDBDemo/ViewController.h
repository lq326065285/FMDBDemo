//
//  ViewController.h
//  FMDBDemo
//
//  Created by 李强 on 14-12-22.
//  Copyright (c) 2014年 思埠集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textID;
@property (weak, nonatomic) IBOutlet UITextField *textAge;
- (IBAction)clickAddData:(id)sender;
- (IBAction)clickDeleteData:(id)sender;
- (IBAction)clickChangeData:(id)sender;
- (IBAction)clickSelectData:(id)sender;

@end

