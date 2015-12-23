//
//  PlayersViewController.h
//  WarCards
//
//  Created by Stefan Vrancianu on 21/12/15.
//  Copyright © 2015 Stefan Vrancianu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PlayersViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *playerOneNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *playerTwoNameTextField;

@end
