//
//  AIFLogger.m
//  POICollect
//  日志
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "AIFLogger.h"
#import "AIFService.h"
#import "AIFURLResponse.h"
#import "NSObject+AXNetworkingMethods.h"
#import "NSMutableString+AXNetworkingMethods.h"

@implementation AIFLogger

+ (void)logDebugInfoWithRequest:(NSURLRequest*)request apiName:(NSString*)apiName service:(AIFService*)service requestParams:(id)requestParams httpMethod:(NSString*)httpMethod
{
#ifdef DEBUG
    BOOL isOnline = NO;
    if ([service respondsToSelector:@selector(isOnline)]) {
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[service methodSignatureForSelector:@selector(isOnline)]];
        invocation.target = service;
        invocation.selector = @selector(isOnline);
        [invocation invoke];
        [invocation getReturnValue:&isOnline];
    }

    NSMutableString* logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];

    [logString appendFormat:@"API Name:\t\t%@\n", [apiName AIF_defaultValue:@"N/A"]];
    [logString appendFormat:@"Method:\t\t\t%@\n", [httpMethod AIF_defaultValue:@"N/A"]];
    //    [logString appendFormat:@"Version:\t\t%@\n", [service.apiVersion AIF_defaultValue:@"N/A"]];
    [logString appendFormat:@"Service:\t\t%@\n", [service class]];
    [logString appendFormat:@"Status:\t\t\t%@\n", isOnline ? @"online" : @"offline"];
    //    [logString appendFormat:@"Public Key:\t\t%@\n", [service.publicKey AIF_defaultValue:@"N/A"]];
    //    [logString appendFormat:@"Private Key:\t%@\n", [service.privateKey AIF_defaultValue:@"N/A"]];
    [logString appendFormat:@"Params:\n%@", requestParams];

    [logString appendURLRequest:request];

    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n"];
    NSLog(@"%@", logString);
#endif
}

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse*)response resposeString:(NSString*)responseString request:(NSURLRequest*)request error:(NSError*)error
{
#ifdef DEBUG
    BOOL shouldLogError = error ? YES : NO;

    NSMutableString* logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];

    [logString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    [logString appendFormat:@"Content:\n\t%@\n\n", responseString];
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }

    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];

    [logString appendURLRequest:request];

    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];

    NSLog(@"%@", logString);
#endif
}

+ (void)logDebugInfoWithCachedResponse:(AIFURLResponse*)response methodName:(NSString*)methodName serviceIdentifier:(AIFService*)service
{
#ifdef DEBUG
    NSMutableString* logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                      Cached Response                       =\n==============================================================\n\n"];

    [logString appendFormat:@"API Name:\t\t%@\n", [methodName AIF_defaultValue:@"N/A"]];
    //    [logString appendFormat:@"Version:\t\t%@\n", [service.apiVersion AIF_defaultValue:@"N/A"]];
    [logString appendFormat:@"Service:\t\t%@\n", [service class]];
    //    [logString appendFormat:@"Public Key:\t\t%@\n", [service.publicKey AIF_defaultValue:@"N/A"]];
    //    [logString appendFormat:@"Private Key:\t%@\n", [service.privateKey AIF_defaultValue:@"N/A"]];
    [logString appendFormat:@"Method Name:\t%@\n", methodName];
    [logString appendFormat:@"Params:\n%@\n\n", response.requestParams];
    [logString appendFormat:@"Content:\n\t%@\n\n", response.contentString];

    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    NSLog(@"%@", logString);
#endif
}

+ (instancetype)sharedInstance
{
    static AIFLogger* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AIFLogger alloc] init];
    });
    return sharedInstance;
}

- (void)logWithActionCode:(NSString*)actionCode params:(NSDictionary*)params
{
}

@end
