//
//  DetailViewController.h
//  ProlificLibrary
//
//  Created by Chao Li on 11/17/14.
//  Copyright (c) 2014 Columbia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSString *bookTitle;
@property (strong, nonatomic) NSString *bookAuthor;
@property (strong, nonatomic) NSString *bookTags;
@property (strong, nonatomic) NSString *bookPublisher;
@property (strong, nonatomic) NSString *lastCheckedOut;
@property (strong, nonatomic) NSString *lastCheckedOutBy;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastCheckOutLabel;



@end
