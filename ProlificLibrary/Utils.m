//
//  Utils.m
//  ProlificLibrary
//
//  Created by Chao Li on 11/17/14.
//  Copyright (c) 2014 Columbia. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(void)showAlertView:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
