//
//  TPTileSetTextureProvider.h
//  tappyPlane
//
//  Created by Fenkins on 11/12/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

// This class will imply singleton pattern

#import <Foundation/Foundation.h>

@interface TPTileSetTextureProvider : NSObject
+(instancetype)getProvider;
-(void)randomizeTileSet;
@end
