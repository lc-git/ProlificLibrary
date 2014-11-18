//
//  DetailViewController.m
//  ProlificLibrary
//
//  Created by Chao Li on 11/17/14.
//  Copyright (c) 2014 Columbia. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) NSString *dateString;

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
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    _dateString = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@",_dateString);
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"What's your name?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertview show];
    [self.view addSubview:alertview];
}


#pragma marks - UIAlertView Delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"%@",[alertView textFieldAtIndex:0].text);
        WebServiceCalls *ws = [[WebServiceCalls alloc]init];
        ws.delegate = self;
        [ws checkOutBook:_bookID username:[alertView textFieldAtIndex:0].text checkoutTime:_dateString];
    }
}

#pragma marks - WebServiceCalls Delegates
-(void)jsonParsedToArrayDone:(int)httpStatusCode data:(NSArray *)data{
    if (httpStatusCode ==200) {
        
    }else{
        [Utils showAlertView:@"Http Status Error" message:@"Get wrong status code"];
    }
}


- (void)connectionFailed:(NSError *)error{
    [Utils showAlertView:@"Conection Error" message:[error localizedDescription]];
}

@end
