//
//  ColorWheel.m
//  RandomFunFacts
//
//  Created by Varun Bansal on 4/1/16.
//  Copyright © 2016 NStarInteractive. All rights reserved.
//

#import "ColorWheel.h"

@interface ColorWheel ()

@property (nonatomic, strong) NSArray *colorDatabase;

@end

@implementation ColorWheel

- (id)init
{
    self = [super init];
    if (self) {
        _colorDatabase = [[NSArray alloc] initWithObjects:
                         @"#39add1", // light blue
                         @"#3079ab", // dark blue
                         @"#c25975", // mauve
                         @"#e15258", // red
                         @"#f9845b", // orange
                         @"#838cc7", // lavender
                         @"#7d669e", // purple
                         @"#53bbb4", // aqua
                         @"#51b46d", // green
                         @"#e0ab18", // mustard
                         @"#637a91", // dark gray
                         @"#f092b0", // pink
                         @"#b7c0c7",  // light gray
                         nil];
    }
    return self;
    
}

- (UIColor *)getRandomColor
{
    int randomNumber = rand() % [_colorDatabase count];
    NSString *colorHexString = [_colorDatabase objectAtIndex:randomNumber];
    
    NSScanner *scanner = [NSScanner scannerWithString:colorHexString];
    [scanner setScanLocation:1]; // bypass '#' character
    
    unsigned rgbValue = 0;
    
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
