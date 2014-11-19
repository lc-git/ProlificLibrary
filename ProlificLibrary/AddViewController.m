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
    
    _titleText.delegate = self;
    _authorText.delegate = self;
    _publisherText.delegate = self;
    _tagsText.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Pressed Events

- (IBAction)submitButtonPressed:(id)sender {
    if (_titleText.text.length == 0 || _authorText.text.length == 0) {
        [Utils showAlertView:@"Invalid Input" message:@"Book title or book author can't be empty."];
    }else{
        WebServiceCalls *ws = [[WebServiceCalls alloc]init];
        ws.delegate = self;
        [ws addBookTitle:_titleText.text author:_authorText.text pushliser:_publisherText.text categories:_tagsText.text];
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    if (_authorText.text.length == 0 && _titleText.text.length == 0 && _tagsText.text.length == 0 && _publisherText.text.length == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you really want to leave with unsaved change?" delegate:self cancelButtonTitle:@"Stay" otherButtonTitles:@"Leave", nil];
        alertview.tag = 1;
        [alertview show];
        [self.view addSubview:alertview];
    }
}

#pragma mark - UIAlertView Delegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if(buttonIndex == 1){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else if (alertView.tag == 2){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - WebServiceCalls Delegates

-(void)jsonParsedToArrayDone:(int)httpStatusCode data:(NSArray *)data{
    if (httpStatusCode ==200) {
        NSLog(@"Add new book");
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Congratulation" message:@"You add a new book!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertview.tag = 2;
        [alertview show];
        [self.view addSubview:alertview];
    }else{
        [Utils showAlertView:@"Http Status Error" message:@"Get wrong status code"];
    }
}


- (void)connectionFailed:(NSError *)error{
    [Utils showAlertView:@"Conection Error" message:[error localizedDescription]];
}


#pragma mark - UITextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}



@end
