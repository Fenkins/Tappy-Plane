//
//  TPScrollingNode.m
//  tappyPlane
//
//  Created by Fenkins on 29/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "TPScrollingNode.h"

@implementation TPScrollingNode

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed {
    if (self.scrolling) {
        self.position = CGPointMake(self.position.x + self.horyzontalScrollSpeed * timeElapsed, self.position.y);
    }
}

@end
