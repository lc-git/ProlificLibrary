//
//  WebServiceCalls.h
//  ProlificLibrary
//
//  Created by Chao Li on 11/17/14.
//  Copyright (c) 2014 Columbia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@class WebServiceCalls;


@protocol WebServiceCallDelegate <NSObject>

- (void)jsonParsedToArrayDone:(int)httpStatusCode data:(NSArray *)data;
- (void)connectionFailed:(NSError *)error;

@end

@interface WebServiceCalls : NSObject

@property (weak, nonatomic) id <WebServiceCallDelegate> delegate;
@property (nonatomic,strong)NSMutableData *responseData;
@property (nonatomic, assign)int statusCode;

//Custom Method
-(void)downloadBooks;
-(void)checkOutBook:(NSNumber *)bookID username:(NSString *)name checkoutTime:(NSString *)time;

@end
