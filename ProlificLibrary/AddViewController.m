//
//  AddViewController.m
//  ProlificLibrary
//
//  Created by Chao Li on 11/17/14.
//  Copyright (c) 2014 Columbia. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)submitButtonPressed:(id)sender {
    if (_titleText.text.length == 0 || _authorText.text.length == 0) {
        [Utils showAlertView:@"Invalid Input" message:@"Book title or book author can't be empty."];
    }
    WebServiceCalls *ws = [[WebServiceCalls alloc]init];
    ws.delegate = self;
    [ws addBookTitle:_titleText.text author:_authorText.text pushliser:_publisherText.text categories:_tagsText.text];
}

//- (IBAction)doneButtonPressed:(id)sender {
//    if (_authorText.text.length == 0 && _titleText.text.length == 0 && _tagsText.text.length == 0 && _publisherText.text.length == 0) {
//        [self goBack:nil];
//    }else{
//        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you really want to leave with unsaved change?" delegate:self cancelButtonTitle:@"Stay" otherButtonTitles:@"Leave", nil];
//        [alertview show];
//        [self.view addSubview:alertview];
//    }
//}

- (IBAction)doneButtonPressed:(id)sender {
    if (_authorText.text.length == 0 && _titleText.text.length == 0 && _tagsText.text.length == 0 && _publisherText.text.length == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you really want to leave with unsaved change?" delegate:self cancelButtonTitle:@"Stay" otherButtonTitles:@"Leave", nil];
        [alertview show];
        [self.view addSubview:alertview];
    }
}

#pragma marks - UIAlertView Delegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma marks - WebServiceCalls Delegates
-(void)jsonParsedToArrayDone:(int)httpStatusCode data:(NSArray *)data{
    if (httpStatusCode ==201) {
        NSLog(@"Add new book");
    }else{
        [Utils showAlertView:@"Http Status Error" message:@"Get wrong status code"];
    }
}


- (void)connectionFailed:(NSError *)error{
    [Utils showAlertView:@"Conection Error" message:[error localizedDescription]];
}



@end
