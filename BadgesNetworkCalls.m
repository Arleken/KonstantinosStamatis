//
//  BadgesNetworkCalls.m
//  schoox
//
//  Created by Kostas Stamatis on 09/10/2017.
//  Copyright © 2017 Schoox. All rights reserved.
//

#import "BadgesNetworkCalls.h"
#import "Utils.h"

#define NetworkError 1
#define NoInternetError 2
#define JsonParseError 3
#define JsonContainsError 4
#define UnknownError 5
#define HourlyWorkerFailedCheck 6
#define RequestLocationServicesAccessError 7

@implementation BadgesNetworkCalls

-(void) awardBadge:(id<BadgesNetworkCallsDelegate>)delegate :(NSString*)requestAddress
{
    NSURL *requestURL=[NSURL URLWithString:requestAddress];
    [self connectToService : delegate : nil : requestURL withCompletionHandler:^(NSData *data)
     {
         if (data != nil) {
             NSError *error;
             NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
             if (error != nil) {
                 if(delegate!=nil)
                     [delegate errorOccuredWithObject:[[ErrorObject alloc] initWithId:[NSNumber numberWithInt:JsonParseError] andDescription:@""]];
             }
             else{
                 [delegate serviceResultAwardBadge:returnedDictionary];
             }}}];
}

-(void) revokeBadge:(id<BadgesNetworkCallsDelegate>)delegate :(NSString*)requestAddress
{
    NSURL *requestURL=[NSURL URLWithString:requestAddress];
    [self connectToService : delegate : nil : requestURL withCompletionHandler:^(NSData *data)
     {
         if (data != nil) {
             NSError *error;
             NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
             if (error != nil) {
                 if(delegate!=nil)
                     [delegate errorOccuredWithObject:[[ErrorObject alloc] initWithId:[NSNumber numberWithInt:JsonParseError] andDescription:@""]];
             }
             else{
                 [delegate serviceResultRevokeBadge:returnedDictionary];
             }}}];
}

-(void) openBadge:(id<BadgesNetworkCallsDelegate>)delegate :(NSString*)requestAddress
{
    NSURL *requestURL=[NSURL URLWithString:requestAddress];
    [self connectToService : delegate : nil : requestURL withCompletionHandler:^(NSData *data)
     {
         if (data != nil) {
             NSError *error;
             NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
             if (error != nil) {
                 if(delegate!=nil)
                     [delegate errorOccuredWithObject:[[ErrorObject alloc] initWithId:[NSNumber numberWithInt:JsonParseError] andDescription:@""]];
             }
             else{
                 [delegate serviceResultOpenBadge:[BadgeOpenDetails deserializeJsonDictionary:returnedDictionary]];
             }}}];
}

-(void)connectToService: (id<BadgesNetworkCallsDelegate>) delegate : (NSDictionary *) postParams : (NSURL*) serviceUrl withCompletionHandler : (void (^)(NSData *))completionHandler
{
    NSMutableString *basicAuthCredentials=(NSMutableString*)[@"" stringByAppendingFormat:@"%@:%@",[[SchooxAppDataHolder getKeychainWrapper] myObjectForKey:(__bridge id)kSecAttrAccount],[[SchooxAppDataHolder getKeychainWrapper] myObjectForKey:(__bridge id)kSecValueData]];
    NSString *authValue=[NSString stringWithFormat:@"Basic %@", [Utils stringUsingAFBase64EncodeForString:basicAuthCredentials]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serviceUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    [request addValue:authValue forHTTPHeaderField:@"Authorization"];
    
    if(postParams!=nil) {
        NSError *jsonError;
        NSData *jsonData=[NSJSONSerialization dataWithJSONObject:postParams options:NSJSONWritingPrettyPrinted error:&jsonError];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
    }
    
    NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
      {
          if (error != nil)
          {
              if ([error code] == -1009)
              {
                  //error in the connections (the credentials are supposed to be correct because they are returned from the previous service correctly)
                  ALog(@"request error %@", [error localizedDescription]);
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if(delegate!=nil)
                          [delegate errorOccuredWithObject:[[ErrorObject alloc] initWithId:[NSNumber numberWithInt:NoInternetError] andDescription:@""]];
                  });
              }
              //else network error
              else
              {
                  ALog(@"request error %@", [error localizedDescription]);
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if(delegate!=nil)
                          [delegate errorOccuredWithObject:[[ErrorObject alloc] initWithId:[NSNumber numberWithInt:NetworkError] andDescription:@""]];
                  });
              }
          }
          else{
              // If no error occurs, check the HTTP status code.
              NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
              
              // If it's other than 200, then show it on the console.
              if (HTTPStatusCode != 200)
              {
                  ALog(@"request error %@", [error localizedDescription]);
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if(delegate!=nil)
                          [delegate errorOccuredWithObject:[[ErrorObject alloc] initWithId:[NSNumber numberWithInt:NetworkError] andDescription:@""]];
                  });
              }
              else
                  //Call the completion handler with the returned data on the main thread.
                  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                      completionHandler(data);
                  }];
          }
      }] resume];
}

- (NSString*)base64EncodedString:(NSString*)stringToEncode {
    return [[stringToEncode dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}
@end
