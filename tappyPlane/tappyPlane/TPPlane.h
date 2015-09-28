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

-(void)setRandomColor;
-(void)update;

@end
