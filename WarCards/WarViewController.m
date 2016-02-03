//
//  WarViewController.m
//  WarCards
//
//  Created by Stefan Vrancianu on 27/01/16.
//  Copyright © 2016 Stefan Vrancianu. All rights reserved.
//

#import "WarViewController.h"
#import "Card.h"
#import "ViewController.h"

@interface WarViewController ()

@end

@implementation WarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.playerOneWarName setText:self.playerOneName];
    [self.playerTwoWarName setText:self.playerTwoName];
    
    self.playerOneWarCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.playerOneWarDeck objectAtIndex:0] valueOfCard ] , [[self.playerOneWarDeck objectAtIndex:0] kind]]];
    
    self.playerTwoWarCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.playerTwoWarDeck objectAtIndex:0] valueOfCard ] , [[self.playerTwoWarDeck objectAtIndex:0] kind]]];
    
    
}

- (void) saveConditionInfo {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:self.conditon forKey:@"kCondition"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) removeConditionKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"kCondition"];
    [userDefaults synchronize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)warButton:(id)sender {
    
    if([[self.playerOneWarDeck objectAtIndex:1] valueOfCard] != [[self.playerTwoWarDeck objectAtIndex:1] valueOfCard])
    {
        
        self.playerOneWarCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.playerOneWarDeck objectAtIndex:1] valueOfCard ] , [[self.playerOneWarDeck objectAtIndex:1] kind]]];
        
        self.playerTwoWarCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.playerTwoWarDeck objectAtIndex:1] valueOfCard ] , [[self.playerTwoWarDeck objectAtIndex:1] kind]]];
    
        if([[self.playerOneWarDeck objectAtIndex:1] valueOfCard] < [[self.playerTwoWarDeck objectAtIndex:1] valueOfCard])
        {
            [self.playerTwoWarDeck addObject:[self.playerOneWarDeck objectAtIndex:0]];
            [self.playerTwoWarDeck addObject:[self.playerOneWarDeck objectAtIndex:1]];
            [self.playerOneWarDeck removeObjectAtIndex:0];
            [self.playerOneWarDeck removeObjectAtIndex:1];
            [self.playerTwoWarDeck addObject:[self.playerTwoWarDeck objectAtIndex:0]];
            [self.playerTwoWarDeck addObject:[self.playerTwoWarDeck objectAtIndex:1]];
            [self.playerTwoWarDeck removeObjectAtIndex:0];
            [self.playerTwoWarDeck removeObjectAtIndex:1];
            [self.playerTwoWonLabel setText:@"Winner"];
            [self.playerOneWonLabel setText:@"Looser"];
            self.warButton.hidden = YES;
            [self removeConditionKey];
            self.conditon = TRUE;
            [self saveConditionInfo];
        }
        else
        {
            [self.playerOneWarDeck addObject:[self.playerTwoWarDeck objectAtIndex:0]];
            [self.playerOneWarDeck addObject:[self.playerTwoWarDeck objectAtIndex:1]];
            [self.playerTwoWarDeck removeObjectAtIndex:0];
            [self.playerTwoWarDeck removeObjectAtIndex:1];
            [self.playerOneWarDeck addObject:[self.playerOneWarDeck objectAtIndex:0]];
            [self.playerOneWarDeck addObject:[self.playerOneWarDeck objectAtIndex:1]];
            [self.playerOneWarDeck removeObjectAtIndex:0];
            [self.playerOneWarDeck removeObjectAtIndex:1];
            [self.playerOneWonLabel setText:@"Winner"];
            [self.playerTwoWonLabel setText:@"Looser"];
            self.warButton.hidden = YES;
            [self removeConditionKey];
            self.conditon = TRUE;
            [self saveConditionInfo];        }

    }
    else
    {
        
        self.playerOneWarCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.playerOneWarDeck objectAtIndex:2] valueOfCard ] , [[self.playerOneWarDeck objectAtIndex:2] kind]]];
        
        self.playerTwoWarCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.playerTwoWarDeck objectAtIndex:2] valueOfCard ] , [[self.playerTwoWarDeck objectAtIndex:2] kind]]];
        
        
        if([[self.playerOneWarDeck objectAtIndex:2] valueOfCard] < [[self.playerTwoWarDeck objectAtIndex:2] valueOfCard])
        {
            [self.playerTwoWarDeck addObject:[self.playerOneWarDeck objectAtIndex:0]];
            [self.playerTwoWarDeck addObject:[self.playerOneWarDeck objectAtIndex:1]];
            [self.playerTwoWarDeck addObject:[self.playerOneWarDeck objectAtIndex:2]];
            [self.playerOneWarDeck removeObjectAtIndex:0];
            [self.playerOneWarDeck removeObjectAtIndex:1];
            [self.playerOneWarDeck removeObjectAtIndex:2];
            [self.playerTwoWarDeck addObject:[self.playerTwoWarDeck objectAtIndex:0]];
            [self.playerTwoWarDeck addObject:[self.playerTwoWarDeck objectAtIndex:1]];
            [self.playerTwoWarDeck addObject:[self.playerTwoWarDeck objectAtIndex:2]];
            [self.playerTwoWarDeck removeObjectAtIndex:0];
            [self.playerTwoWarDeck removeObjectAtIndex:1];
            [self.playerTwoWarDeck removeObjectAtIndex:2];
            [self.playerTwoWonLabel setText:@"Winner"];
            [self.playerOneWonLabel setText:@"Looser"];
            self.warButton.hidden = YES;
            [self removeConditionKey];
            self.conditon = FALSE;
            [self saveConditionInfo];
        }
        else
        {
            [self.playerOneWarDeck addObject:[self.playerTwoWarDeck objectAtIndex:0]];
            [self.playerOneWarDeck addObject:[self.playerTwoWarDeck objectAtIndex:1]];
            [self.playerOneWarDeck addObject:[self.playerTwoWarDeck objectAtIndex:2]];
            [self.playerTwoWarDeck removeObjectAtIndex:0];
            [self.playerTwoWarDeck removeObjectAtIndex:1];
            [self.playerTwoWarDeck removeObjectAtIndex:2];
            [self.playerOneWarDeck addObject:[self.playerOneWarDeck objectAtIndex:0]];
            [self.playerOneWarDeck addObject:[self.playerOneWarDeck objectAtIndex:1]];
            [self.playerOneWarDeck addObject:[self.playerOneWarDeck objectAtIndex:2]];
            [self.playerOneWarDeck removeObjectAtIndex:0];
            [self.playerOneWarDeck removeObjectAtIndex:1];
            [self.playerOneWarDeck removeObjectAtIndex:2];
            [self.playerOneWonLabel setText:@"Winner"];
            [self.playerTwoWonLabel setText:@"Looser"];
            self.warButton.hidden = YES;
            [self removeConditionKey];
            self.conditon = FALSE;
            [self saveConditionInfo];
        }


        
    }
}


@end
