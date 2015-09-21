//
//  TPGameScene.m
//  tappyPlane
//
//  Created by Fenkins on 21/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "TPGameScene.h"

@implementation TPGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        NSLog(@"Size: %f, %f", self.size.width, self.size.height);
    }
    return self;
}

@end
