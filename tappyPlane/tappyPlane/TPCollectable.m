//
//  TPCollectable.m
//  tappyPlane
//
//  Created by Fenkins on 06/12/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "TPCollectable.h"

@implementation TPCollectable

-(void)collect {
    [self runAction:[SKAction removeFromParent]];
    if (self.delegate) {
        [self.delegate wasCollected:self];
    }
}

@end
