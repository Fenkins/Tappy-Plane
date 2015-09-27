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
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
        
        // Init array to hold animations in it
        _planeAnimations = [[NSMutableArray alloc]init];
        
        // Load animation plist file
        NSString *path = [[NSBundle mainBundle]pathForResource:@"PlaneAnimations" ofType:@"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:path];
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

-(SKAction*)animationFromArray:(NSArray*)textureNames withDuration:(CGFloat)duration {
    // Create array to hold textures
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    
    // Get planes atlas
    SKTextureAtlas *planesAtlas = [SKTextureAtlas atlasNamed:@"Planes"];
    
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
