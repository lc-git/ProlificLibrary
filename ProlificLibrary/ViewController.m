//
//  ViewController.m
//  ProlificLibrary
//
//  Created by Chao Li on 11/17/14.
//  Copyright (c) 2014 Columbia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WebServiceCalls *ws = [[WebServiceCalls alloc]init];
    ws.delegate = self;
    [ws downloadBooks];
    
    
    //_tableView.backgroundColor = [UIColor colorWithRed:117.0/255.0 green:142.0/255.0 blue:183.0/255/0 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _booksArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"BookCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    //cell.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:229.0/255.0 blue:231.0/255/0 alpha:1.0];
    cell.textLabel.text = [[_booksArr objectAtIndex:indexPath.row] objectForKey:TITLE];
    
    //cell.textLabel.textColor = [UIColor colorWithRed:117.0/255.0 green:142.0/255.0 blue:183.0/255/0 alpha:1.0];
    
    cell.detailTextLabel.text = [[_booksArr objectAtIndex:indexPath.row] objectForKey:AUTHOR];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:117.0/255.0 green:142.0/255.0 blue:183.0/255/0 alpha:1.0];
    
    return cell;
}


#pragma marks - Table View Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


#pragma marks - WebServiceCall Delegates
-(void)jsonParsedToArrayDone:(int)httpStatusCode data:(NSArray *)data{
    if (httpStatusCode ==200) {
        NSLog(@"%@",data);
        [self parsePatientData:data];
    }else{
        [Utils showAlertView:@"Http Status Error" message:@"Get wrong status code"];
    }
}


- (void)connectionFailed:(NSError *)error{
    [Utils showAlertView:@"Conection Error" message:[error localizedDescription]];
}

#pragma marks - Custom Methods
-(void)parsePatientData:(NSArray *)data{
    _booksArr = data;
    [_tableView reloadData];
}

@end
