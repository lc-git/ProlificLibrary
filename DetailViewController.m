//
//  DetailViewController.m
//  ProlificLibrary
//
//  Created by Chao Li on 11/17/14.
//  Copyright (c) 2014 Columbia. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    _titleLabel.text = _bookTitle;
    _authorLabel.text = _bookAuthor;
    _publisherLabel.text = _bookPublisher;
    _tagsLabel.text = _bookTags;
    NSString *lastCheckOutString = [NSString stringWithFormat:@"%@ @ %@",_lastCheckedOutBy, _lastCheckedOut];
    _lastCheckOutLabel.text = lastCheckOutString;
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
- (IBAction)CheckoutButtonPressed:(id)sender {
    
}

@end
