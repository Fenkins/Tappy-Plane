//
//  TPPlane.h
//  tappyPlane
//
//  Created by Fenkins on 22/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TPPlane : SKSpriteNode

@property (nonatomic) BOOL engineRunning;
@property (nonatomic) BOOL accelerating;
@property (nonatomic) BOOL acceleratingEnded;
@property (nonatomic) BOOL crashed;

-(void)setRandomColor;
-(void)update;
-(void)reset;
-(void)collide:(SKPhysicsBody*)body;

@end
