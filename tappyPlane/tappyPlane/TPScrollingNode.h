//
//  TPScrollingNode.h
//  tappyPlane
//
//  Created by Fenkins on 29/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TPScrollingNode : SKNode

@property (nonatomic) CGFloat horyzontalScrollSpeed; // distance per scroll per second
@property (nonatomic) BOOL scrolling;

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed;

@end
