//
//  TPObstacleLayer.m
//  tappyPlane
//
//  Created by Fenkins on 27/11/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "TPObstacleLayer.h"
#import "TPConstants.h"
#import "TPTileSetTextureProvider.h"
#import "TPConstants.h"
#import "TPChallengeProvider.h"

@interface TPObstacleLayer()
@property  (nonatomic) CGFloat marker;
@end

static const CGFloat kTPMarkerBuffer = 200.0;
static const CGFloat kTPVerticalGap = 90.0;
static const CGFloat kTPSpaceBetweenObstaclesSet = 180.0;
static const int kTPCollectableVerticalRange = 100.0;
static const CGFloat kTPCollectableClearance = 50.0;

@implementation TPObstacleLayer
-(void)reset {
    // Loop trough child nodes & reposition them, so we could reuse them later.
    for (SKNode *node in self.children) {
        node.position = CGPointMake(-1000.0, 0.0);
        // Also reusing and updating textures
        if (node.name == kTPMountainUp) {
            ((SKSpriteNode*)node).texture = [[TPTileSetTextureProvider getProvider]getTextureForKey:@"mountainUp"];
        }
        if (node.name == kTPMountainDown) {
            ((SKSpriteNode*)node).texture = [[TPTileSetTextureProvider getProvider]getTextureForKey:@"mountainDown"];
        }
    }
    // Reposition marker.
    if (self.scene) {
        self.marker = self.scene.size.width + kTPMarkerBuffer;
    }
}

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
    /*
    // Get mountains nodes
    SKSpriteNode* mountainUp = [self getUnusedObjectForKey:(NSString*)kTPMountainUp];
    SKSpriteNode* mountainDown = [self getUnusedObjectForKey:(NSString*)kTPMountainDown];
    
    // Calculate maximum variation
    CGFloat maxVariation = (mountainUp.size.height + mountainDown.size.height + kTPVerticalGap)-(self.ceiling - self.floor);
    CGFloat yAdjustment = arc4random_uniform(maxVariation);
    
    // Positioning mountain nodes
    mountainUp.position = CGPointMake(self.marker, self.floor + mountainUp.size.height*0.5 - yAdjustment);
    mountainDown.position = CGPointMake(self.marker, mountainUp.position.y + mountainDown.size.height + kTPVerticalGap);
    
    // Get collectable star node
    SKSpriteNode *collectable = [self getUnusedObjectForKey:(NSString*)kTPCollectableStar];
    
    // Position collectable
    CGFloat midPoint = mountainUp.position.y + (mountainUp.size.height*0.5) + (kTPVerticalGap *0.5);
    CGFloat yPosition = midPoint + arc4random_uniform(kTPCollectableVerticalRange) - arc4random_uniform(kTPCollectableVerticalRange*0.5);
    
    // We are doint that so we wont receive stars spawned below floor/ceiling
    yPosition = fmaxf(yPosition, self.floor + kTPCollectableClearance);
    yPosition = fminf(yPosition, self.ceiling - kTPCollectableClearance);
    
    collectable.position = CGPointMake(self.marker + kTPSpaceBetweenObstaclesSet*0.5, yPosition);
    */
    
    NSArray* challenge = [[TPChallengeProvider getProvider]getRandomChallenge];
    
    CGFloat furthestItem = 0.0;
    
    for (TPChallengeItem* item in challenge) {
        SKSpriteNode* object = [self getUnusedObjectForKey:item.obstacleKey];
        object.position = CGPointMake(item.position.x+self.marker, item.position.y);
        if (item.position.x > furthestItem) {
            furthestItem = item.position.x;
        }
    }
    
    // Reposition marker
    self.marker += furthestItem + kTPSpaceBetweenObstaclesSet;
}

// Method to reuse object which passed the left edge of the screen, or create a new one
-(SKSpriteNode*)getUnusedObjectForKey:(NSString*)key {
    if (self.scene) {
        // Getting the left edge of the screen in local coordinates
        CGFloat leftEdgeInLocalCoord = [self.scene convertPoint:CGPointMake(-self.scene.size.height*self.scene.anchorPoint.x, 0) toNode:self].x;
        
        // Try to find object for key at the left of the screen
        for (SKSpriteNode* node in self.children) {
            if (node.name == key && node.frame.origin.x + node.frame.size.width < leftEdgeInLocalCoord) {
                // Return unused object
                return node;
            }
        }
    }
    
    // Couldnt find unused node for key, so creating one
    return [self createObjectForKey:key];
}

-(SKSpriteNode*)createObjectForKey:(NSString*)key {
    SKSpriteNode *object = nil;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    if (key == kTPMountainUp || kTPMountainUpAlternate) {
        // Old implementation, we will replace that one with code that will pick us texture based on the name provided in plist file according to TPTileSetTextureProvider
        // object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrass"]];
        object = [SKSpriteNode spriteNodeWithTexture:[[TPTileSetTextureProvider getProvider] getTextureForKey:key]];
        
        
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
    } else if (key == kTPMountainDown || kTPMountainDownAlternate) {
        //object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrassDown"]];
        object = [SKSpriteNode spriteNodeWithTexture:[[TPTileSetTextureProvider getProvider] getTextureForKey:key]];

        
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
        object.physicsBody.categoryBitMask = kTPCategoryGround;
        
        [self addChild:object];
    } else if (key == kTPCollectableStar) {
        object = [TPCollectable spriteNodeWithTexture:[atlas textureNamed:@"starGold"]];
        ((TPCollectable*)object).pointValue = 1;
        ((TPCollectable*)object).delegate = self.collectableDelegate;
        object.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:object.size.width * 0.3];
        object.physicsBody.categoryBitMask = kTPCategoryCollectable;
        object.physicsBody.dynamic = NO;
        
        [self addChild:object];
    }
    if (object) {
        object.name = key;
    }
    
    return object;
}

@end
