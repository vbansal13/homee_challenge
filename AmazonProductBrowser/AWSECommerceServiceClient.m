//
//  AWSECommerceServiceClient.m
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/19/16.
//  Copyright © 2016 Homee. All rights reserved.
//

#import "AWSECommerceServiceClient.h"
#import "AmazonAuthUtils.h"
#import "PicoXMLElement.h"
#import "CommonTypes.h"
#import "SOAP11Fault.h"
#import "RWMAmazonProductAdvertisingManager.h"

@implementation AWSECommerceServiceClient

/**
 update url according to your local location, see a list of supported location at the end of the wsdl:
 http://webservices.amazon.com/AWSECommerceService/AWSECommerceService.wsdl
 */
//static NSString *const AWSECServiceURLString = @"https://webservices.amazon.cn/onca/soap?Service=AWSECommerceService";
static NSString *const AWSECServiceURLString = @"https://webservices.amazon.com/onca/soap?Service=AWSECommerceService";

NSString *const AWSAccessKeyId = @"YAKIAJRKX2SICB6AGRG7A";
NSString *const AWSSecureKeyId = @"MI89CnDCvP/c1F/mhuuUkd5ysjU1jtYkqwbwOLzH";

static NSString *const AuthHeaderNS = @"http://security.amazonaws.com/doc/2007-01-01/";


+ (AWSECommerceServiceClient *)sharedClient {
    static AWSECommerceServiceClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AWSECommerceServiceClient alloc] initWithEndpointURL:[NSURL URLWithString:AWSECServiceURLString]];
    });
    
    return _sharedClient;
}

/**
 Authentication of SOAP request
 see details here: http://docs.aws.amazon.com/AWSECommerceService/latest/DG/NotUsingWSSecurity.html
 */
- (void)authenticateRequest:(NSString *)action {
    
    // build timestamp
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dataFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *timestamp = [dataFormatter stringFromDate:[NSDate date]];
    
    // build signature
    NSString *signatureInput = [action stringByAppendingString:timestamp];
    NSString *signature = [AmazonAuthUtils sha256HMac:[signatureInput dataUsingEncoding:NSUTF8StringEncoding] withKey:AWSSecureKeyId];
    
    // add SOAP headers
    self.customSoapHeaders = [NSMutableArray array];
    PicoXMLElement *accessKeyElement = [[PicoXMLElement alloc] init];
    accessKeyElement.nsUri = AuthHeaderNS;
    accessKeyElement.name = @"AWSAccessKeyId";
    accessKeyElement.value = AWSAccessKeyId;
    [self.customSoapHeaders addObject:accessKeyElement];
    PicoXMLElement *timestampElement = [[PicoXMLElement alloc] init];
    timestampElement.nsUri = AuthHeaderNS;
    timestampElement.name = @"Timestamp";
    timestampElement.value = timestamp;
    [self.customSoapHeaders addObject:timestampElement];
    PicoXMLElement *signatureElement = [[PicoXMLElement alloc] init];
    signatureElement.nsUri = AuthHeaderNS;
    signatureElement.name = @"Signature";
    signatureElement.value = signature;
    [self.customSoapHeaders addObject:signatureElement];
}

- (void)searchProductCategory:(NSString *)categoryName withKeyword:(NSString *)keyword executeBlock:(void (^)(NSMutableArray *))callbackBlock
{
    
    RWMAmazonProductAdvertisingManager *manager = [[RWMAmazonProductAdvertisingManager alloc] initWithAccessKeyID:AWSAccessKeyId secret:AWSSecureKeyId];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *parameters = [@{
                                         @"Service" : @"AWSECommerceService",
                                         @"Operation" : @"ItemSearch",
                                         @"ResponseGroup" : @"ItemAttributes,Images,EditorialReview",
                                         @"AssociateTag" : @"nstarinteract-20"
                                         } mutableCopy];
    
    //if (type == RWMAmazonProductAdvertisingISBN13) {
        //[parameters setObject:@"EAN" forKey:@"IdType"];
        [parameters setObject:categoryName forKey:@"SearchIndex"];
        [parameters setObject:@"All" forKey:@"Condition"];
    //}
    
    [manager enqueueRequestOperationWithMethod:@"GET" parameters:[parameters copy] success:^(id responseObject) {
        NSLog(responseObject);
        callbackBlock(nil);
    } failure:^(NSError *error) {
        NSLog(error.localizedDescription);
        callbackBlock(nil);
    }];
    
    
    return;
        // get shared client
    AWSECommerceServiceClient *client = [AWSECommerceServiceClient sharedClient];
    client.debug = YES;
    
    // build request
    ItemSearch *request = [[ItemSearch alloc] init];
    request.associateTag = @"nstarinteract-20"; // seems any tag is ok
    request.shared = [[ItemSearchRequest alloc] init];
    request.shared.searchIndex = categoryName;
    request.shared.keywords = keyword;
    request.shared.responseGroup = [NSMutableArray arrayWithObjects:@"Images", @"ItemAttributes", @"Offers", nil];
    
    // authenticate the request
    // see : http://docs.aws.amazon.com/AWSECommerceService/latest/DG/NotUsingWSSecurity.html
    [client authenticateRequest:@"ItemSearch"];
    [client itemSearch:request success:^(ItemSearchResponse *responseObject) {
        
        
        
        // success handling logic
        if (responseObject.items.count > 0) {
            Items *items = [responseObject.items objectAtIndex:0];
            if (items.item.count > 0) {
                callbackBlock(items.item);
                
                // Show found items in the table
                //[_tableData removeAllObjects];
                //[_tableData addObjectsFromArray:items.item];
                //[self.tableView reloadData];
            } else {
                // no result
                //[self.view makeToast:@"No result" duration:3.0 position:@"center"];
                callbackBlock(nil);
            }
            
        } else {
            // no result
            //[self.view makeToast:@"No result" duration:3.0 position:@"center"];
            callbackBlock(nil);
        }
    } failure:^(NSError *error, id<PicoBindable> soapFault) {
        // stop progress activity
        //[self.view hideToastActivity];
        
        // error handling logic
        if (error) { // http or parsing error
            //[self.view makeToast:[error localizedDescription] duration:3.0 position:@"center" title:@"Error"];
            callbackBlock(nil);
        } else if (soapFault) {
            SOAP11Fault *soap11Fault = (SOAP11Fault *)soapFault;
            //[self.view makeToast:soap11Fault.faultstring duration:3.0 position:@"center" title:@"SOAP Fault"];
            callbackBlock(nil);
        }
    }];
}

@end
