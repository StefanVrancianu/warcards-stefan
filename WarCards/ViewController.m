//
//  ViewController.m
//  WarCards
//
//  Created by Stefan Vrancianu on 16/12/15.
//  Copyright © 2015 Stefan Vrancianu. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "PlayersViewController.h"
#import "Card.h"

static NSString *kDeckArrayKey = @"keyDeckArray";
static NSString *kDeckRandomKey = @"keyDeckRandom";
static NSString *kStatePlayerOneKey = @"kForStateOfPlayerOneKey";
static NSString *kStatePlayerTwoKey = @"kForStateOfPlayerTwoKey";
static NSString *kRememberDeck1Key = @"kRememberDeck1Key";
static NSString *kRememberDeck2Key = @"kRememberDeck2Key";
static NSString *kRememrDeck2Key = @"kRememberDeck2Key";

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView *viewC;
@property (weak, nonatomic) IBOutlet UIImageView *PlayerTwoCard;
@property (weak, nonatomic) IBOutlet UIImageView *PlayerOneCard;
@property (weak, nonatomic) IBOutlet UILabel *ScorePlayerTwo;
@property (weak, nonatomic) IBOutlet UILabel *ScorePlayerOne;
@property (strong, nonatomic) NSMutableArray *Deck;
@property (strong, nonatomic) NSMutableArray *RandDeck;
@property (strong, nonatomic) NSMutableArray *PlayerOneDeck;
@property (strong, nonatomic) NSMutableArray *PlayerTwoDeck;
@property (strong, nonatomic) NSMutableArray *rememberingDeck1;
@property (strong, nonatomic) NSMutableArray *rememberingDeck2;
@property (nonatomic) NSInteger conditie;



@end

@implementation ViewController

@synthesize playerOneNameLabel;
@synthesize playerTwoNameLabel;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
        // --------------- Metoda prepareForSegue (Setarea parametrilor in alt ViewControler) ---------------- //
    
    if ([segue.identifier isEqualToString:@"gotoSecond"]){
        
        SecondViewController *svc = segue.destinationViewController;
        svc.ihandsPlayed = self.numOfHands;
        svc.ihandsOwned  = self.handsWonbyPlayerOne;
        svc.iValueToReceive = [[self.rememberingDeck2 lastObject] valueOfCard];
        svc.iKindToReceive = [[self.rememberingDeck2 lastObject] kind];
        
    }
    else if([segue.identifier isEqualToString:@"gotoThird"]) {
        ThirdViewController *tvc = segue.destinationViewController;
        tvc.ihandsPlayed3 = self.numOfHands;
        tvc.ihandsOwned3 = self.handsWonbyPlayerTwo;
        tvc.iValueToReceive3 = [[self.rememberingDeck1 lastObject] valueOfCard];
        tvc.iKindToReceive3 = [[self.rememberingDeck1 lastObject] kind];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
        // --------------- Conditia pentru rularea ultimei stari ---------------- //
    if([[NSUserDefaults standardUserDefaults] objectForKey:kDeckArrayKey] != nil){
        [self retrieveStateGame];
    }
    else {
        [self makeDeck];
        [self shuffleDeck];
    }
        // --------------- Cheile pentru numele jucatorilor + setarea numelor ---------------- //
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id myObj = [userDefaults objectForKey:@"key1"];
    id myObj2 = [userDefaults objectForKey:@"key2"];
    
    [self.playerOneNameLabel setText: myObj];
    [self.playerTwoNameLabel setText: myObj2];
    
    // --------------- Afisarea starii salvate ---------------- //
    if (self.conditie == 1) {
        self.PlayerTwoCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.rememberingDeck1 lastObject] valueOfCard ] , [[self.rememberingDeck1 objectAtIndex:0] kind]]];
        
        self.PlayerOneCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.rememberingDeck2 lastObject] valueOfCard ] , [[self.rememberingDeck2 objectAtIndex:0] kind]]];
    }
    else if(self.conditie == 0){
        self.PlayerTwoCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.rememberingDeck2 lastObject] valueOfCard ] , [[self.rememberingDeck2 objectAtIndex:0] kind]]];
        
        self.PlayerOneCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.rememberingDeck1 lastObject] valueOfCard ] , [[self.rememberingDeck1 objectAtIndex:0] kind]]];
    }

    // --------------- Abonarea la notificarea AppDidEnterBackground ---------------- //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveStateOfTheGame:)
                                                 name:@"saveStateOfGame"
                                               object:nil];
    
    
    self.rememberingDeck1 = [NSMutableArray arrayWithCapacity:52];
    self.rememberingDeck2 = [NSMutableArray arrayWithCapacity:52];
    
}

- (void) makeDeck {
    
    //      Crearea pachetului de carti (Deck)      //
    
    
    self.Deck = [NSMutableArray arrayWithCapacity:52];
    for(int i = 1; i <= 52; i++)
    {
        Card *card = [[Card alloc] init];
        if(i<=13)
        {
            [card initCard:i withKind:@"trefla"];
        }
        else if(i>13 && i<= 26)
        {
            [card initCard:i-13 withKind:@"rosu"];
        }
        else if(i>26 && i<=39)
        {
            [card initCard:i-26 withKind:@"negru"];
        }
        else if(i>39)
        {
            [card initCard:i-39 withKind:@"caro"];
        }
        [self.Deck addObject:card];
        
        
    }

    
}

- (void) shuffleDeck {
    
    //      Amestecarea pachetului de carti si impartirea lui in doua jumatati egale        //
    
    
    NSUInteger count = [self.Deck count];
    if (count > 1)
    {
        for (NSUInteger i = count - 1; i > 0; --i)
        {
            [self.Deck exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
        }
    }
    
    self.RandDeck  = [NSMutableArray arrayWithArray:self.Deck];
    self.PlayerOneDeck = [NSMutableArray arrayWithCapacity:52];
    self.PlayerTwoDeck = [NSMutableArray arrayWithCapacity:52];
    for(NSUInteger i = 0; i < [self.RandDeck count]; i++)
    {
        if(i < [self.RandDeck count]/2)
        {
            [self.PlayerOneDeck addObject:[self.RandDeck objectAtIndex:i]];
        }
        else
        {
            [self.PlayerTwoDeck addObject:[self.RandDeck objectAtIndex:i]];
        }
        
    }

    
}

- (void) saveStateOfTheGame: (NSNotification *)notification {
    
        // --------------- Salvarea datelor cu NSUserDefaults ---------------- //
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.Deck] forKey: kDeckArrayKey];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.PlayerOneDeck] forKey: kStatePlayerOneKey];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.PlayerTwoDeck] forKey: kStatePlayerTwoKey];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.RandDeck] forKey: kDeckRandomKey];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.rememberingDeck1] forKey: kRememberDeck1Key];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.rememberingDeck2] forKey: kRememberDeck2Key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    

}

- (void) retrieveStateGame {
    
        // --------------- Metoda de recuperare a detelor din UserDefaults ---------------- //
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    id result = [userDefaults objectForKey: kDeckArrayKey];
    self.Deck = [NSKeyedUnarchiver unarchiveObjectWithData: result];
    
    id result1 = [userDefaults objectForKey: kStatePlayerOneKey];
    self.PlayerOneDeck = [NSKeyedUnarchiver unarchiveObjectWithData: result1];
    
    id result2 = [userDefaults objectForKey: kStatePlayerTwoKey];
    self.PlayerTwoDeck = [NSKeyedUnarchiver unarchiveObjectWithData: result2];
    
    id result3 = [userDefaults objectForKey: kDeckRandomKey];
    self.RandDeck = [NSKeyedUnarchiver unarchiveObjectWithData: result3];
    
    id result4 = [userDefaults objectForKey: kRememberDeck1Key];
    self.rememberingDeck1 = [NSKeyedUnarchiver unarchiveObjectWithData: result4];
    
    id result5 = [userDefaults objectForKey: kRememberDeck2Key];
    self.rememberingDeck2 = [NSKeyedUnarchiver unarchiveObjectWithData: result5];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


        // --------------- Butonul cu LOGICA JOCULUI ---------------- //


- (IBAction)buttonOfWar:(id)sender {
    
    NSString *alertMessege;
    
    
    if([self.PlayerOneDeck count] > 0 && [self.PlayerTwoDeck count] > 0)
    {
        self.PlayerOneCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.PlayerOneDeck objectAtIndex:0] valueOfCard ] , [[self.PlayerOneDeck objectAtIndex:0] kind]]];
        
        self.PlayerTwoCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.PlayerTwoDeck objectAtIndex:0] valueOfCard ] , [[self.PlayerTwoDeck objectAtIndex:0] kind]]];
        
        
        [self.ScorePlayerOne setText:[NSString stringWithFormat:@"Score: %ld", [self.PlayerOneDeck count]]];
        [self.ScorePlayerTwo setText:[NSString stringWithFormat:@"Score: %ld", [self.PlayerTwoDeck count]]];
        
        if([[self.PlayerOneDeck objectAtIndex:0] valueOfCard] < [[self.PlayerTwoDeck objectAtIndex:0] valueOfCard])
        {
            [self.rememberingDeck1 addObject:[self.PlayerOneDeck objectAtIndex:0]];
            [self.rememberingDeck2 addObject:[self.PlayerTwoDeck objectAtIndex:0]];
            [self.PlayerTwoDeck addObject:[self.PlayerOneDeck objectAtIndex:0]];
            [self.PlayerOneDeck removeObjectAtIndex:0];
            [self.PlayerTwoDeck addObject:[self.PlayerTwoDeck objectAtIndex:0]];
            [self.PlayerTwoDeck removeObjectAtIndex:0];
            self.handsWonbyPlayerOne++;
            self.conditie = 1;
        }
        else
        {
            [self.rememberingDeck1 addObject:[self.PlayerOneDeck objectAtIndex:0]];
            [self.rememberingDeck2 addObject:[self.PlayerTwoDeck objectAtIndex:0]];
            [self.PlayerOneDeck addObject:[self.PlayerTwoDeck objectAtIndex:0]];
            [self.PlayerTwoDeck removeObjectAtIndex:0];
            [self.PlayerOneDeck addObject:[self.PlayerOneDeck objectAtIndex:0]];
            [self.PlayerOneDeck removeObjectAtIndex:0];
            self.handsWonbyPlayerTwo++;
            self.conditie = 0;
        }
        
    }
    else
    {
        if( [self.PlayerOneDeck count] == 0)
            alertMessege = @"Player Two Wins !";
        else if([self.PlayerTwoDeck count] == 0)
            alertMessege = @"Player One Wins !";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game" message:alertMessege preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    self.numOfHands++;
    
    
}


@end
