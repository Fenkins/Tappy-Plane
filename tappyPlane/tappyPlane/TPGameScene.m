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
        SKSpriteNode *plane1 = [SKSpriteNode spriteNodeWithImageNamed:@"planeBlue1"];
        plane1.position = CGPointMake(50.0, 50.0);
        [self addChild:plane1];
        SKSpriteNode *plane2 = [SKSpriteNode spriteNodeWithImageNamed:@"planeGreen1"];
        plane2.position = CGPointMake(100.0, 50.0);
        [self addChild:plane2];
        SKSpriteNode *plane3 = [SKSpriteNode spriteNodeWithImageNamed:@"planeRed1"];
        plane3.position = CGPointMake(150.0, 50.0);
        [self addChild:plane3];
        SKSpriteNode *plane4 = [SKSpriteNode spriteNodeWithImageNamed:@"planeYellow1"];
        plane4.position = CGPointMake(200.0, 50.0);
        [self addChild:plane4];
    }
    return self;
}

@end
