//
//  TPObstacleLayer.m
//  tappyPlane
//
//  Created by Fenkins on 27/11/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "TPObstacleLayer.h"

@interface TPObstacleLayer()
@property  (nonatomic) CGFloat marker;
@end

static const CGFloat kTPMarkerBuffer = 200.0;
static const NSString* kTPMountainUp = @"MountainUp";
static const NSString* kTPMountainDown = @"MountainDown";

@implementation TPObstacleLayer
-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed {
    [super updateWithTimeElapsed:timeElapsed];
    if (self.scrolling && self.scene) {
        // Find the marker's location in the screen's coord
        CGPoint markerLocationInScene = [self convertPoint:CGPointMake(self.marker, 0) toNode:self.scene];
        // When marker comes to screen, add some new obstacles (including anchorPoint check)
        if (markerLocationInScene.x - (self.scene.size.width * self.scene.anchorPoint.x) < self.scene.size.width + kTPMarkerBuffer) {
            [self addObstacleSet];
        }
    }
}

-(void)addObstacleSet {
    
}

-(SKSpriteNode*)createObjectForKey:(NSString*)key {
    SKSpriteNode *object = nil;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    if (key == kTPMountainUp) {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrass"]];
        [self addChild:object];
    } else if (key == kTPMountainDown) {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrassDown"]];
        [self addChild:object];
    }
    if (object) {
        object.name = key;
    }
    
    return object;
}

@end
