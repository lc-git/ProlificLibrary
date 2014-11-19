//
//  AddViewController.h
//  ProlificLibrary
//
//  Created by Chao Li on 11/17/14.
//  Copyright (c) 2014 Columbia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceCalls.h"
#import "Utils.h"
#import "Constant.h"

@interface AddViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,WebServiceCallDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *authorText;
@property (weak, nonatomic) IBOutlet UITextField *publisherText;
@property (weak, nonatomic) IBOutlet UITextField *tagsText;

@end
