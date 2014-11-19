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
    
    
    //_tableView.backgroundColor = [UIColor colorWithRed:117.0/255.0 green:142.0/255.0 blue:183.0/255/0 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    WebServiceCalls *ws = [[WebServiceCalls alloc]init];
    ws.delegate = self;
    [ws downloadBooks];
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


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_booksArr removeObjectAtIndex:indexPath.row];
    [_tableView reloadData];
    WebServiceCalls *ws = [[WebServiceCalls alloc]init];
    ws.delegate = self;
    [ws deleteBook:[[_booksArr objectAtIndex:indexPath.row] objectForKey:ID]];
    
}

#pragma marks - Table View Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *bookDic = [_booksArr objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"DetailSegue" sender:bookDic];
}


#pragma marks - WebServiceCall Delegates
-(void)jsonParsedToArrayDone:(int)httpStatusCode data:(NSArray *)data{
    if (httpStatusCode == 200) {
        if (data.count > 0) {
            NSLog(@"%@",data);
            [self parsePatientData:data];
        }else{
            NSLog(@"Delete All");
        }
    } else if(httpStatusCode == 204){
        NSLog(@"Delete one book");
    }else{
        [Utils showAlertView:@"Http Status Error" message:@"Get wrong status code"];
    }
}


- (void)connectionFailed:(NSError *)error{
    [Utils showAlertView:@"Conection Error" message:[error localizedDescription]];
}

#pragma marks - Custom Methods
-(void)parsePatientData:(NSArray *)data{
    _booksArr = [[NSMutableArray alloc] initWithArray:data];
    [_tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"DetailSegue"]) {
        DetailViewController *vc = segue.destinationViewController;
        NSDictionary *bookDic = (NSDictionary *)sender;
        vc.bookTitle = [bookDic objectForKey:TITLE];
        vc.bookAuthor = [bookDic objectForKey:AUTHOR];
        vc.bookTags = [bookDic objectForKey:CATEGORIES];
        vc.bookID = [bookDic objectForKey:ID];
        
        NSString *publisher;
        if ([[bookDic valueForKey:PUBLISHER] isEqual:[NSNull null]]) {
            publisher =@"";
        }else{
            publisher = [bookDic valueForKey:PUBLISHER];
        }
        
        NSString *lastCheckOut;
        if ([[bookDic valueForKey:LASTCHECKEDOUT] isEqual:[NSNull null]]) {
            lastCheckOut =@"NO Check Out";
        }else{
            lastCheckOut = [bookDic valueForKey:LASTCHECKEDOUT];
        }
        
        NSString *lastCheckOutBy;
        if ([[bookDic valueForKey:LASTCHECKEDOUTBY] isEqual:[NSNull null]]) {
            lastCheckOutBy =@"NO Check Out";
        }else{
            lastCheckOutBy = [bookDic valueForKey:LASTCHECKEDOUTBY];
        }
        
        vc.bookPublisher = publisher;
        vc.lastCheckedOut = lastCheckOut;
        vc.lastCheckedOutBy = lastCheckOutBy;
    }
    
}

- (IBAction)deleteAllButtonPressed:(id)sender {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you really want to delete all the books?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alertview show];
    [self.view addSubview:alertview];
}


#pragma marks - UIAlertView Delegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        WebServiceCalls *ws = [[WebServiceCalls alloc]init];
        ws.delegate = self;
        [ws deleteAllBooks];
    }
}
@end
