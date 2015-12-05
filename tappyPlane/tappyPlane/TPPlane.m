//
//  TPPlane.m
//  tappyPlane
//
//  Created by Fenkins on 22/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "TPPlane.h"
#import "TPConstants.h"

@interface TPPlane()

// Array of actions
@property (nonatomic) NSMutableArray* planeAnimations;
@property (nonatomic) SKEmitterNode* puffTrailEmiter;
@property (nonatomic) CGFloat puffTrailBirthRate;
@end

static NSString* const kTPKeyPlaneAnimation = @"PlaneAnimation";
static const CGFloat kTPMaxAltitude = 300.0;

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
        self.physicsBody.categoryBitMask = kTPCategoryPlane;
        self.physicsBody.contactTestBitMask = kTPCategoryGround | kTPCategoryCollectable;
        self.physicsBody.collisionBitMask = kTPCategoryGround;
        
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
    // By adding && !self.crashed we are making sure we cant enable engine's running state if the plane is already crashed
    _engineRunning = engineRunning && !self.crashed;
    if (engineRunning) {
        self.puffTrailEmiter.targetNode = self.parent;
        [self actionForKey:kTPKeyPlaneAnimation].speed = 1;
        self.puffTrailEmiter.particleBirthRate = self.puffTrailBirthRate;

    } else {
        [self actionForKey:kTPKeyPlaneAnimation].speed = 0;
        self.puffTrailEmiter.particleBirthRate = 0;
    }
}

-(void)setRandomColor {
    [self removeActionForKey:kTPKeyPlaneAnimation];
    SKAction *animation = [self.planeAnimations objectAtIndex:arc4random_uniform(self.planeAnimations.count)];
    [self runAction:animation withKey:kTPKeyPlaneAnimation];
    if (!self.engineRunning) {
        [self actionForKey:kTPKeyPlaneAnimation].speed = 0;
    }
}

-(void)update {
    if (self.accelerating && self.position.y < (kTPMaxAltitude - self.frame.size.height/2) && self.acceleratingEnded) {
        [self.physicsBody applyForce:CGVectorMake(0.0, 350.0)];
        self.acceleratingEnded = NO;
    }
    if (!self.crashed) {
        // This will rotate our plane up/down 57 degrees/1radiant (400/400)
        self.zRotation = fmaxf(fminf(self.physicsBody.velocity.dy, 300), -300) / 300;
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

-(void)setAccelerating:(BOOL)accelerating {
    // By adding && !self.crashed we are making sure we cant enable acceleration state if the plane is already crashed
    _accelerating = accelerating && !self.crashed;
}

-(void)setCrashed:(BOOL)crashed {
    _crashed = crashed;
    if (crashed) {
        self.engineRunning = NO;
        self.accelerating = NO;
        
    }
}

-(void)reset {
    // Set plane's initial values
    self.crashed = NO;
    self.engineRunning = YES;
    
    // This way our plane will setup straight and wont fuck around
    self.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    self.zRotation = 0.0;
    self.physicsBody.angularVelocity = 0.0;
    [self setRandomColor]; 
}

-(void)collide:(SKPhysicsBody *)body {
    // Ignore collision if already crashed
    if (!self.crashed) {
        if (body.categoryBitMask == kTPCategoryGround) {
            // Hit the ground.
            self.crashed = YES;
        }
        if (body.categoryBitMask == kTPCategoryCollectable) {
            [body.node runAction:[SKAction removeFromParent]];
        }
    }
}

@end
