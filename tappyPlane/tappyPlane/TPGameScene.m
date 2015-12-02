//
//  TPGameScene.m
//  tappyPlane
//
//  Created by Fenkins on 21/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "TPGameScene.h"
#import "TPPlane.h"
#import "TPAlien.h"
#import "TPScrollingLayer.h"
#import "TPConstants.h"
#import "TPObstacleLayer.h"

@interface TPGameScene ()

@property (nonatomic) TPPlane *player;
@property (nonatomic) TPAlien *alien;
@property (nonatomic) SKNode *world;
@property (nonatomic) TPScrollingLayer *background;
@property (nonatomic) TPObstacleLayer *obstacles;
@property (nonatomic) TPScrollingLayer *foreground;

@end

static const CGFloat kMinFPS = 10.0 / 60.0;

@implementation TPGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // Set background color
        self.backgroundColor = [SKColor colorWithRed:213/255.0 green:237/255.0 blue:247/255.0 alpha:1.0];
        
        // Get atlas file
        SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        // Setup physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
        self.physicsWorld.contactDelegate = self;
        
        // Setup world
        _world = [[SKNode alloc]init];
        [self addChild:_world];
        
        // Setup background
        NSMutableArray *backgroundTiles = [[NSMutableArray alloc]init];
        for (int i=0; i<3; i++) {
            [backgroundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
        }
        
        _background = [[TPScrollingLayer alloc]initWithTiles:backgroundTiles];
        _background.horyzontalScrollSpeed = -60;
        _background.scrolling = YES;
        [_world addChild:_background];
        
        // Setup obstacles
        _obstacles = [[TPObstacleLayer alloc]init];
        _obstacles.horyzontalScrollSpeed = -80;
        _obstacles.scrolling = YES;
        _obstacles.floor = 0;
        _obstacles.ceiling = self.size.height;
        [_world addChild:_obstacles];
        
        // Setup foreground
        _foreground = [[TPScrollingLayer alloc]initWithTiles:@[[self generateGroundTile],
                                                               [self generateGroundTile],
                                                               [self generateGroundTile]]];
        _foreground.horyzontalScrollSpeed = -80.0;
        _foreground.scrolling = YES;
        [_world addChild:_foreground];
        
        // Setup player
        _player = [[TPPlane alloc]init];
        _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        _player.physicsBody.affectedByGravity = NO;
        [_world addChild:_player];
        
        // We have a code that is setting target node for emitter to parent node, so we need to switch the engineRunning AFTER adding node to the parent
        [self newGame]; // Includes engineRunning = YES:
        
        // Setup alien
//        _alien = [[TPAlien alloc]init];
//        _alien.position = CGPointMake(self.size.width * 0.5 + _alien.size.width, self.size.height * 0.5);
//        [_world addChild:_alien];
        
    }
    return self;
}


-(SKSpriteNode*)generateGroundTile {
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"groundGrass"]];
    
    sprite.anchorPoint = CGPointZero;
    
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 16 - offsetX, 19 - offsetY);
    CGPathAddLineToPoint(path, NULL, 20 - offsetX, 14 - offsetY);
    CGPathAddLineToPoint(path, NULL, 43 - offsetX, 12 - offsetY);
    CGPathAddLineToPoint(path, NULL, 66 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 78 - offsetX, 31 - offsetY);
    CGPathAddLineToPoint(path, NULL, 124 - offsetX, 33 - offsetY);
    CGPathAddLineToPoint(path, NULL, 154 - offsetX, 22 - offsetY);
    CGPathAddLineToPoint(path, NULL, 174 - offsetX, 21 - offsetY);
    CGPathAddLineToPoint(path, NULL, 185 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 218 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 236 - offsetX, 13 - offsetY);
    CGPathAddLineToPoint(path, NULL, 254 - offsetX, 13 - offsetY);
    CGPathAddLineToPoint(path, NULL, 268 - offsetX, 7 - offsetY);
    CGPathAddLineToPoint(path, NULL, 285 - offsetX, 7 - offsetY);
    CGPathAddLineToPoint(path, NULL, 298 - offsetX, 21 - offsetY);
    CGPathAddLineToPoint(path, NULL, 318 - offsetX, 23 - offsetY);
    CGPathAddLineToPoint(path, NULL, 329 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 372 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 382 - offsetX, 22 - offsetY);
    CGPathAddLineToPoint(path, NULL, 403 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 403 - offsetX, 0 - offsetY);
    
    CGPathCloseSubpath(path);
    
    // By using bodyWithEdgeChain we are disallowing our body from moving
    sprite.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    sprite.physicsBody.categoryBitMask = kTPCategoryGround;
    
    // We could see the border of our physicsBody thx to dis
    SKShapeNode *bodyShape = [SKShapeNode node];
    bodyShape.path = path;
    bodyShape.strokeColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
    bodyShape.lineWidth = 1.0;
    [sprite addChild:bodyShape];
    
    return sprite;
}

-(void)newGame {
    // Resetting layers
    self.foreground.position = CGPointZero;
    [self.foreground layoutTiles];
    self.obstacles.position = CGPointZero;
    [self.obstacles reset];
    // Obstacles wont scroll until we begin the game in touchesBegan
    self.obstacles.scrolling = NO;
    self.background.position = CGPointMake(0.0, 30.0);
    [self.background layoutTiles];
    
    // Reset plane
    self.player.position = CGPointMake(self.size.width / 2, self.size.width / 2);
    self.player.physicsBody.affectedByGravity = NO;
    [self.player reset];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (self.player.crashed) {
            [self newGame];
        } else {
            self.player.accelerating = YES;
            self.player.physicsBody.affectedByGravity = YES;
            // Obstacles will scroll now
            self.obstacles.scrolling = YES;
        }
        
//  Code for alienz and stuff
//        self.player.engineRunning = !self.player.engineRunning;
//        [self.player setRandomColor];
//        [self.alien changeAlien];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        self.player.accelerating = NO;
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    if (contact.bodyA.categoryBitMask == kTPCategoryPlane) {
        [self.player collide:contact.bodyB];
    } else if (contact.bodyB.categoryBitMask == kTPCategoryPlane) {
        [self.player collide:contact.bodyA];
    }
}

-(void)update:(NSTimeInterval)currentTime {
    // Calculating time betweet calls
    static NSTimeInterval lastCallTime; // this variable will retain itself between method calls (static)
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > kMinFPS) {
        timeElapsed = kMinFPS;
    }
    lastCallTime = currentTime;
    
    [self.player update];
    if (!self.player.crashed) {
        [self.background updateWithTimeElapsed:timeElapsed];
        [self.obstacles updateWithTimeElapsed:timeElapsed];
        [self.foreground updateWithTimeElapsed:timeElapsed];
    }
}

@end
