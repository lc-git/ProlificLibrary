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

@implementation ViewController{
    NSArray *searchResults;
}

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

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }else{
        return _booksArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"BookCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] objectForKey:TITLE];
        cell.detailTextLabel.text = [[searchResults objectAtIndex:indexPath.row] objectForKey:AUTHOR];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:117.0/255.0 green:142.0/255.0 blue:183.0/255/0 alpha:1.0];
    }else{
        //cell.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:229.0/255.0 blue:231.0/255/0 alpha:1.0];
        cell.textLabel.text = [[_booksArr objectAtIndex:indexPath.row] objectForKey:TITLE];
        
        //cell.textLabel.textColor = [UIColor colorWithRed:117.0/255.0 green:142.0/255.0 blue:183.0/255/0 alpha:1.0];
        
        cell.detailTextLabel.text = [[_booksArr objectAtIndex:indexPath.row] objectForKey:AUTHOR];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:117.0/255.0 green:142.0/255.0 blue:183.0/255/0 alpha:1.0];
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_booksArr removeObjectAtIndex:indexPath.row];
    [_tableView reloadData];
    WebServiceCalls *ws = [[WebServiceCalls alloc]init];
    ws.delegate = self;
    [ws deleteBook:[[_booksArr objectAtIndex:indexPath.row] objectForKey:ID]];
    
}

#pragma mark - Table View Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *bookDic;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        bookDic = [searchResults objectAtIndex:indexPath.row];
    }else{
        bookDic = [_booksArr objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:@"DetailSegue" sender:bookDic];
    searchResults = [[NSArray alloc] init];
    self.searchDisplayController.searchBar.text = nil;
}


#pragma mark - WebServiceCall Delegates
-(void)jsonParsedToArrayDone:(int)httpStatusCode data:(NSArray *)data{
    if (httpStatusCode == 200) {
        if (data.count > 0) {
            NSLog(@"%@",data);
            [self parsePatientData:data];
        }else{
            NSLog(@"Delete All");
            _booksArr = [[NSMutableArray alloc]init];
            [_tableView reloadData];
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

#pragma mark - Custom Methods
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
        vc.bookID = [bookDic objectForKey:ID];
        
        NSString *tags;
        if ([[bookDic valueForKey:CATEGORIES] isEqual:[NSNull null]]) {
            tags =@"";
        }else{
            tags = [bookDic valueForKey:CATEGORIES];
        }
        
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
        
        
        vc.bookTags = tags;
        vc.bookPublisher = publisher;
        vc.lastCheckedOut = lastCheckOut;
        vc.lastCheckedOutBy = lastCheckOutBy;
    }
    
}

//Filter to get the search result array
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title contains[c] %@ OR author contains[c] %@", searchText, searchText];
    searchResults = [_booksArr filteredArrayUsingPredicate:resultPredicate];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

#pragma mark - Button Events Pressed
- (IBAction)deleteAllButtonPressed:(id)sender {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you really want to delete all the books?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alertview show];
    [self.view addSubview:alertview];
}


#pragma mark - UIAlertView Delegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        WebServiceCalls *ws = [[WebServiceCalls alloc]init];
        ws.delegate = self;
        [ws deleteAllBooks];
    }
}
@end
