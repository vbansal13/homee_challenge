// Generated by xsd compiler for ios/objective-c
// DO NOT CHANGE!

#import <Foundation/Foundation.h>
#import "PicoClassSchema.h"
#import "PicoPropertySchema.h"
#import "PicoConstants.h"
#import "PicoBindable.h"


@class SOAP11Detail;

/**
 
     Fault reporting structure
   
 
*/
@interface SOAP11Fault : NSObject <PicoBindable> {

@private
    NSString *_faultcode;
    NSString *_faultstring;
    NSString *_faultactor;
    SOAP11Detail *_detail;

}


/**
 (public property)
 
 type : NSString, wrapper for primitive qname
*/
@property (nonatomic, strong) NSString *faultcode;

/**
 (public property)
 
 type : NSString, wrapper for primitive string
*/
@property (nonatomic, strong) NSString *faultstring;

/**
 (public property)
 
 type : NSString, wrapper for primitive string
*/
@property (nonatomic, strong) NSString *faultactor;

/**
 (public property)
 
 type : class SOAP11Detail
*/
@property (nonatomic, strong) SOAP11Detail *detail;


@end
