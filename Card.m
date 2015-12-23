//
//  Card.m
//  WarCards
//
//  Created by Stefan Vrancianu on 16/12/15.
//  Copyright © 2015 Stefan Vrancianu. All rights reserved.
//

#import "Card.h"

static NSString *kCardValueKey = @"key1";
static NSString *kCardKindKey = @"key2";

@implementation Card


// Retrieve and set object properties - Deserialization.
// This is automatically called when the object is deserialized.
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _valueOfCard = [aDecoder decodeIntegerForKey: kCardValueKey];
        _kind = [aDecoder decodeObjectForKey: kCardKindKey];
    }
    return self;
}

// Encode object properties - Serialization.
// This is automatically called when the object is serialized.
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:_valueOfCard forKey: kCardValueKey];
    [coder encodeObject:_kind forKey: kCardKindKey];
}


-(void) initCard: (int) valueOfCard withKind: (NSString *) kind
{
    self.valueOfCard = valueOfCard;
    self.kind = kind;
}

@end
