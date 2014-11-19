//
//  ViewController.h
//  ProlificLibrary
//
//  Created by Chao Li on 11/17/14.
//  Copyright (c) 2014 Columbia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "AddViewController.h"
#import "WebServiceCalls.h"
#import "Utils.h"
#import "Constant.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UISearchControllerDelegate,WebServiceCallDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) NSMutableArray *booksArr;

@end

