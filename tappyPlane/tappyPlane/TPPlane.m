//
//  TPPlane.m
//  tappyPlane
//
//  Created by Fenkins on 22/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "TPPlane.h"

@interface TPPlane()

// Array of actions
@property (nonatomic) NSMutableArray* planeAnimations;
@property (nonatomic) SKEmitterNode* puffTrailEmiter;
@property (nonatomic) CGFloat puffTrailBirthRate;
@end

static NSString* const kKeyPlaneAnimation = @"PlaneAnimation";

@implementation TPPlane

- (instancetype)init
{
    self = [super initWithImageNamed:@"planeBlue1@2x"];
    if (self) {
        // Setup physics body.
        self.anchorPoint = CGPointZero;

        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 42 - offsetX, 20 - offsetY);
        CGPathAddLineToPoint(path, NULL, 36 - offsetX, 34 - offsetY);
        CGPathAddLineToPoint(path, NULL, 10 - offsetX, 35 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 29 - offsetY);
        CGPathAddLineToPoint(path, NULL, 9 - offsetX, 5 - offsetY);
        CGPathAddLineToPoint(path, NULL, 28 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 38 - offsetX, 4 - offsetY);
        
        CGPathCloseSubpath(path);
        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        
        self.physicsBody.mass = 0.065;
        
        // Init array to hold animations in it
        _planeAnimations = [[NSMutableArray alloc]init];
        
        // Load animation plist file
        NSString *animationsPath = [[NSBundle mainBundle]pathForResource:@"PlaneAnimations" ofType:@"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:animationsPath];
        for (NSString* key in animations) {
            [self.planeAnimations addObject:[self animationFromArray:[animations objectForKey:key] withDuration:0.4]];
        }
        
        // Setting puff trail particle effect
        NSString *particleFile = [[NSBundle mainBundle]pathForResource:@"PlanePuffTrail" ofType:@"sks"];
        _puffTrailEmiter = [NSKeyedUnarchiver unarchiveObjectWithFile:particleFile];
        _puffTrailEmiter.position = CGPointMake(-self.size.width*0.5, 0);
        [self addChild:self.puffTrailEmiter];
        self.puffTrailBirthRate = self.puffTrailEmiter.particleBirthRate;
        self.puffTrailEmiter.particleBirthRate = 0;
        
        [self setRandomColor];
    }
    return self;
}

-(void)setEngineRunning:(BOOL)engineRunning {
    _engineRunning = engineRunning;
    if (engineRunning) {
        self.puffTrailEmiter.targetNode = self.parent;
        [self actionForKey:kKeyPlaneAnimation].speed = 1;
        self.puffTrailEmiter.particleBirthRate = self.puffTrailBirthRate;

    } else {
        [self actionForKey:kKeyPlaneAnimation].speed = 0;
        self.puffTrailEmiter.particleBirthRate = 0;
    }
}

-(void)setRandomColor {
    [self removeActionForKey:kKeyPlaneAnimation];
    SKAction *animation = [self.planeAnimations objectAtIndex:arc4random_uniform(self.planeAnimations.count)];
    [self runAction:animation withKey:kKeyPlaneAnimation];
    if (!self.engineRunning) {
        [self actionForKey:kKeyPlaneAnimation].speed = 0;
    }
}

-(void)update {
    if (self.accelerating) {
        [self.physicsBody applyForce:CGVectorMake(0.0, 100.0)];
    }
}

-(SKAction*)animationFromArray:(NSArray*)textureNames withDuration:(CGFloat)duration {
    // Create array to hold textures
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    
    // Get planes atlas
    SKTextureAtlas *planesAtlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    // Loop trough textureNames array and load textures
    for (NSString *textureName in textureNames) {
        [frames addObject:[planesAtlas textureNamed:textureName]];
    }
    
    // Calculate time per frame
    CGFloat frameTime = duration / (CGFloat)frames.count;
    
    // Create and return animation action
    return [SKAction repeatActionForever:[SKAction animateWithTextures:frames timePerFrame:frameTime]];
}

@end
