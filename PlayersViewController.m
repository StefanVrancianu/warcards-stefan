//
//  PlayersViewController.m
//  WarCards
//
//  Created by Stefan Vrancianu on 21/12/15.
//  Copyright © 2015 Stefan Vrancianu. All rights reserved.
//

#import "PlayersViewController.h"
#import "ViewController.h"
#import "AppDelegate.h" 


@interface PlayersViewController ()


@end

@implementation PlayersViewController

@synthesize playerOneNameTextField;
@synthesize playerTwoNameTextField;



- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self.playerOneNameTextField resignFirstResponder];
    [self.playerTwoNameTextField resignFirstResponder];
    
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    playerOneNameTextField.delegate = self;
    playerTwoNameTextField.delegate = self;
    
    
}

- (void) saveNames {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: playerOneNameTextField.text forKey: @"key1"];
    [userDefaults setObject: playerTwoNameTextField.text forKey: @"key2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.delegate setNameForPlayerOne: playerOneNameTextField.text andPlayerTwo: playerTwoNameTextField.text];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)submit:(id)sender {
    
    [self saveNames];
    [self.statusNameChangedLabel setText:@"Your names have been changed!"];
    
}

@end
