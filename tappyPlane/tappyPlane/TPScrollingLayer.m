//
//  TPScrollingLayer.m
//  tappyPlane
//
//  Created by Fenkins on 29/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "TPScrollingLayer.h"

@interface TPScrollingLayer ()
@property (nonatomic) SKSpriteNode* rightMostTile;
@end

@implementation TPScrollingLayer
-(id)initWithTiles:(NSArray *)tileSpriteNodes {
    if (self = [super init]) {
        for (SKSpriteNode *tile in tileSpriteNodes) {
            tile.anchorPoint = CGPointZero;
            tile.name = @"Tile";
            [self addChild:tile];
        }
        [self layoutTiles];
    }
    return self;
}

-(void)layoutTiles {
    self.rightMostTile = nil;
    [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
        node.position = CGPointMake(self.rightMostTile.position.x + self.rightMostTile.size.width, node.position.y);
        self.rightMostTile = (SKSpriteNode*)node;
    }];
}

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed {
    [super updateWithTimeElapsed:timeElapsed];
    if (self.scrolling && self.horyzontalScrollSpeed < 0 && self.scene) {
        [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
            // Looking for position for node in our coordinates system
            CGPoint nodePositionInScene = [self convertPoint:node.position toNode:self.scene];
            if (nodePositionInScene.x + node.frame.size.width <
                -self.scene.size.width * self.scene.anchorPoint.x) {
                // If yes, we more the node
                node.position = CGPointMake(self.rightMostTile.position.x + self.rightMostTile.size.width, node.position.y);
                self.rightMostTile = (SKSpriteNode*)node;
            }
        }];
    }
}

@end
