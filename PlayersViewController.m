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
    
    self.playerOneNameTextField.delegate = self;
    self.playerTwoNameTextField.delegate = self;
    
    
}

- (void) saveNames {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: playerOneNameTextField.text forKey: @"key1"];
    [userDefaults setObject: playerTwoNameTextField.text forKey: @"key2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submit:(id)sender {
    

    [self saveNames];
    [self.statusNameChangedLabel setText:@"Your names have been changed!"];
    
}

@end
