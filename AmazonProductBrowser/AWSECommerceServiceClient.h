//
//  AWSECommerceServiceClient.h
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/19/16.
//  Copyright © 2016 Homee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWSECommerceServicePortType_SOAPClient.h"

extern NSString *const AWSAccessKeyId;

@interface AWSECommerceServiceClient : AWSECommerceServicePortType_SOAPClient

+ (AWSECommerceServiceClient *)sharedClient;

- (void)authenticateRequest:(NSString *)action;

- (void)searchProductCategory:(NSString *)categoryName withKeyword:(NSString *)keyword executeBlock:(void (^)(NSMutableArray *))callbackBlock;

@end
