//
//  ViewController.h
//  WarCards
//
//  Created by Stefan Vrancianu on 16/12/15.
//  Copyright © 2015 Stefan Vrancianu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic) NSInteger handsWonbyPlayerTwo;
@property (nonatomic) NSInteger handsWonbyPlayerOne;
@property (nonatomic) NSInteger numOfHands;

@property (weak, nonatomic) IBOutlet UILabel *playerTwoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerOneNameLabel;


@end

