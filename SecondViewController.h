//
//  SecondViewController.h
//  WarCards
//
//  Created by Stefan Vrancianu on 17/12/15.
//  Copyright © 2015 Stefan Vrancianu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (nonatomic) NSInteger iValueToReceive;
@property (weak, nonatomic) NSString *iKindToReceive;

@property (nonatomic) NSInteger ihandsPlayed;
@property (nonatomic) NSInteger ihandsOwned;



@end
