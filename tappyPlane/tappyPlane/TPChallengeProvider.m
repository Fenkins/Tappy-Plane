//
//  TPChallengeProvider.m
//  tappyPlane
//
//  Created by Fenkins on 26/12/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "TPChallengeProvider.h"
#import "TPConstants.h"

@implementation TPChallengeItem

+ (instancetype)challengeItemWithKey:(NSString*)key andPosition:(CGPoint)position {
    TPChallengeItem* item = [[TPChallengeItem alloc]init];
    item.obstacleKey = key;
    item.position = position;
    return item;
}

@end

@interface TPChallengeProvider()
@property (nonatomic) NSMutableArray* challenges;
@end

@implementation TPChallengeProvider

// We will always get the same instance whenever we call this method
+(instancetype)getProvider {
    static TPChallengeProvider *sharedInstance = nil;
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[TPChallengeProvider alloc]init];
            // Loading all the challenges when first time initialising the sharedInstance
            [sharedInstance loadChallenges];
        }
        return sharedInstance;
    }
}

-(NSArray*)getRandomChallenge {
    return [self.challenges objectAtIndex:arc4random_uniform((uint)self.challenges.count)];
}

-(void)loadChallenges {
    _challenges = [NSMutableArray array];
    
    // Challenge 1
    NSMutableArray* challenge = [NSMutableArray array];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPMountainUp andPosition:CGPointMake(0.0, 105.0)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPMountainDown andPosition:CGPointMake(143.0, 250.0)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPCollectableStar andPosition:CGPointMake(23.0, 290.0)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPCollectableStar andPosition:CGPointMake(128.0, 35.0)]];
    [self.challenges addObject:challenge];
    
    // Challenge 2
    challenge = [NSMutableArray array];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPMountainUp andPosition:CGPointMake(90.0, 25.0)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPMountainDownAlternate andPosition:CGPointMake(0.0, 232.0)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPCollectableStar andPosition:CGPointMake(100.0, 243.0)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPCollectableStar andPosition:CGPointMake(152.0, 205.0)]];
    [self.challenges addObject:challenge];
    
    // Challenge 3
    challenge = [NSMutableArray array];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPMountainUp andPosition:CGPointMake(0.0, 82.0)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPMountainUpAlternate andPosition:CGPointMake(122.0, 0.0)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPMountainDown andPosition:CGPointMake(85.0, 320.0)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPCollectableStar andPosition:CGPointMake(10.0, 213.0)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPCollectableStar andPosition:CGPointMake(81.0, 116.0)]];
    [self.challenges addObject:challenge];
}
@end
