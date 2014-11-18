//
//  WebServiceCalls.m
//  ProlificLibrary
//
//  Created by Chao Li on 11/17/14.
//  Copyright (c) 2014 Columbia. All rights reserved.
//

#import "WebServiceCalls.h"

@implementation WebServiceCalls

-(void)downloadBooks{
    NSString *string = [NSString stringWithFormat:@"%@/books",API_URL];
    [self executingRequest:string];
}

-(void)executingRequest:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( connection )
    {
        _responseData = [[NSMutableData alloc] init];
    }
}

#pragma mark - NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    //NSLog(@"response: %@",response );
    [_responseData setLength:0];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    _statusCode = (int)[httpResponse statusCode];
    
    NSLog(@"This is the http code: %d",_statusCode);
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    NSError *jsonParsingError = nil;
    NSArray *jsonFeed = [NSJSONSerialization JSONObjectWithData:_responseData
                                                        options:kNilOptions
                                                          error:&jsonParsingError];
    
    //NSString *responseStringWithEncoded = [[NSString alloc] initWithData: _responseData encoding:NSUTF8StringEncoding];
    
    if (jsonParsingError) {
        NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
    } else {
        NSLog(@"OBJECT: %@", jsonFeed);
    }
    
    [self.delegate jsonParsedToArrayDone:_statusCode data:jsonFeed];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"ERROR! : %@",[error localizedDescription]);
    connection = nil;
    [_delegate connectionFailed:error];
}
@end
