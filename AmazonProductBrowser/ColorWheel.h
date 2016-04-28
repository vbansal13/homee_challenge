//
//  ColorWheel.h
//  RandomFunFacts
//
//  Created by Varun Bansal on 4/1/16.
//  Copyright © 2016 NStarInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
    ColorWheel
 
    Helper class to get a random color from a list of handpicked colors
 
 */
@interface ColorWheel : NSObject

- (UIColor *)getRandomColor;


@end
