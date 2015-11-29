//
//  TPObstacleLayer.m
//  tappyPlane
//
//  Created by Fenkins on 27/11/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "TPObstacleLayer.h"
#import "TPConstants.h"

@interface TPObstacleLayer()
@property  (nonatomic) CGFloat marker;
@end

static const CGFloat kTPMarkerBuffer = 200.0;
static const NSString* kTPMountainUp = @"MountainUp";
static const NSString* kTPMountainDown = @"MountainDown";
static const CGFloat kTPVerticalGap = 90.0;
static const CGFloat kTPSpaceBetweenObstaclesSet = 180.0;

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
    // Get mountains nodes
    SKSpriteNode* mountainUp = [self createObjectForKey:(NSString*)kTPMountainUp];
    SKSpriteNode* mountainDown = [self createObjectForKey:(NSString*)kTPMountainDown];
    
    // Calculate maximum variation
    CGFloat maxVariation = (mountainUp.size.height + mountainDown.size.height + kTPVerticalGap)-(self.ceiling - self.floor);
    CGFloat yAdjustment = arc4random_uniform(maxVariation);
    
    // Positioning mountain nodes
    mountainUp.position = CGPointMake(self.marker, self.floor + mountainUp.size.height*0.5 - yAdjustment);
    mountainDown.position = CGPointMake(self.marker, mountainUp.position.y + mountainDown.size.height + kTPVerticalGap);
    
    // Reposition marker
    self.marker += kTPSpaceBetweenObstaclesSet;
}

-(SKSpriteNode*)createObjectForKey:(NSString*)key {
    SKSpriteNode *object = nil;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    if (key == kTPMountainUp) {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrass"]];
        
        
        
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, NULL, 23 - offsetX, 90 - offsetY);
        CGPathAddLineToPoint(path, NULL, 31 - offsetX, 96 - offsetY);
        CGPathAddLineToPoint(path, NULL, 51 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 59 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 68 - offsetX, 114 - offsetY);
        CGPathAddLineToPoint(path, NULL, 72 - offsetX, 113 - offsetY);
        CGPathAddLineToPoint(path, NULL, 80 - offsetX, 54 - offsetY);
        CGPathAddLineToPoint(path, NULL, 84 - offsetX, 49 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 0 - offsetY);
        
        CGPathCloseSubpath(path);
        
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        object.physicsBody.categoryBitMask = kTPCategoryGround;
        
        [self addChild:object];
    } else if (key == kTPMountainDown) {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrassDown"]];
        
        
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 23 - offsetX, 109 - offsetY);
        CGPathAddLineToPoint(path, NULL, 30 - offsetX, 104 - offsetY);
        CGPathAddLineToPoint(path, NULL, 52 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 59 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 68 - offsetX, 86 - offsetY);
        CGPathAddLineToPoint(path, NULL, 72 - offsetX, 86 - offsetY);
        CGPathAddLineToPoint(path, NULL, 78 - offsetX, 145 - offsetY);
        CGPathAddLineToPoint(path, NULL, 84 - offsetX, 149 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 198 - offsetY);
        
        CGPathCloseSubpath(path);
        
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        
        
        [self addChild:object];
    }
    if (object) {
        object.name = key;
    }
    
    return object;
}

@end
