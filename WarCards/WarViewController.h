//
//  WarViewController.h
//  WarCards
//
//  Created by Stefan Vrancianu on 27/01/16.
//  Copyright © 2016 Stefan Vrancianu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *playerTwoWarName;
@property (weak, nonatomic) IBOutlet UILabel *playerOneWarName;
@property (weak, nonatomic) IBOutlet UILabel *playerTwoWonLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerOneWonLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerTwoWarCard;
@property (weak, nonatomic) IBOutlet UIImageView *playerOneWarCard;
@property (strong, nonatomic) NSMutableArray *playerOneWarDeck;
@property (strong, nonatomic) NSMutableArray *playerTwoWarDeck;
@property (strong, nonatomic) NSString *playerOneName;
@property (strong, nonatomic) NSString *playerTwoName;
@property (nonatomic, assign) BOOL conditon;

@property (weak, nonatomic) IBOutlet UIButton *warButton;


@end
