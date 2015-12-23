//
//  Card.h
//  WarCards
//
//  Created by Stefan Vrancianu on 16/12/15.
//  Copyright © 2015 Stefan Vrancianu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject <NSCoding>

@property (nonatomic) NSInteger valueOfCard;
@property (nonatomic, strong) NSString *kind;

-(void) initCard: (int) valueOfCard withKind: (NSString *) kind;

@end
