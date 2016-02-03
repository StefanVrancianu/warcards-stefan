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
#import "AppDelegate.h"
#import "WarViewController.h"


static NSString *kDeckArrayKey = @"keyDeckArray";
static NSString *kDeckRandomKey = @"keyDeckRandom";
static NSString *kStatePlayerOneKey = @"kForStateOfPlayerOneKey";
static NSString *kStatePlayerTwoKey = @"kForStateOfPlayerTwoKey";
static NSString *kRememberDeck1Key = @"kRememberDeck1Key";
static NSString *kRememberDeck2Key = @"kRememberDeck2Key";

@interface ViewController () <PlayersViewControllerDelegate>

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
@property (nonatomic) NSInteger scorePlayerOneI;
@property (nonatomic) NSInteger scorePlayerTwoI;
@property (nonatomic) NSInteger condition;
@property (nonatomic, strong) NSString *forSegueCardOneKind;
@property (nonatomic) NSInteger forSegueCardOneValue;
@property (nonatomic, strong) NSString *forSegueCardTwoKind;
@property (nonatomic) NSInteger forSegueCardTwoValue;
@property (nonatomic, assign) BOOL conditionShow;


@end

@implementation ViewController

@synthesize playerOneNameLabel;
@synthesize playerTwoNameLabel;

- (void)setNameForPlayerOne: (NSString *)namePlayerOne andPlayerTwo: (NSString *)namePlayerTwo {
    
    self.playerOneNameLabel.text = namePlayerOne;
    self.playerTwoNameLabel.text = namePlayerTwo;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
        // --------------- Metoda prepareForSegue (Setarea parametrilor in alt ViewControler) ---------------- //
    
    if ([segue.identifier isEqualToString:@"gotoSecond"]){
        
        SecondViewController *svc = segue.destinationViewController;
        svc.ihandsPlayed = self.numOfHands;
        svc.ihandsOwned  = self.handsWonbyPlayerOne;
        svc.iValueToReceive = self.forSegueCardTwoValue;
        svc.iKindToReceive = self.forSegueCardTwoKind;
        
    }
    else if([segue.identifier isEqualToString:@"gotoThird"]) {
        ThirdViewController *tvc = segue.destinationViewController;
        tvc.ihandsPlayed3 = self.numOfHands;
        tvc.ihandsOwned3 = self.handsWonbyPlayerTwo;
        tvc.iValueToReceive3 = self.forSegueCardOneValue;
        tvc.iKindToReceive3 = self.forSegueCardOneKind;
    }
    else if ([[segue destinationViewController] isKindOfClass:[PlayersViewController class]]) {
        PlayersViewController *pvc = (PlayersViewController *)[segue destinationViewController];
        pvc.delegate = self;
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.conditionShow = [userDefaults boolForKey: @"kCondition"];
    
    if(self.conditionShow == TRUE)
    {
        self.PlayerOneCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.PlayerOneDeck objectAtIndex:1] valueOfCard ] , [[self.PlayerOneDeck objectAtIndex:1] kind]]];
        
        self.PlayerTwoCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.PlayerTwoDeck objectAtIndex:1] valueOfCard ] , [[self.PlayerTwoDeck objectAtIndex:1] kind]]];
    }
    else
    {
        self.PlayerOneCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.PlayerOneDeck objectAtIndex:2] valueOfCard ] , [[self.PlayerOneDeck objectAtIndex:2] kind]]];
        
        self.PlayerTwoCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.PlayerTwoDeck objectAtIndex:2] valueOfCard ] , [[self.PlayerTwoDeck objectAtIndex:2] kind]]];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
        // --------------- Conditia pentru rularea ultimei stari ---------------- //
    if([[NSUserDefaults standardUserDefaults] objectForKey:kDeckArrayKey] != nil){
        [self retrieveStateGame];
        
        [self.playerOneNameLabel setText: self.myObj];
        [self.playerTwoNameLabel setText: self.myObj2];

         self.PlayerTwoCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.rememberingDeck2 lastObject] valueOfCard ] , [[self.rememberingDeck2 lastObject] kind]]];
            
         self.PlayerOneCard.image = [UIImage imageNamed: [NSString stringWithFormat:@"%ld_%@", (long)[[self.rememberingDeck1 lastObject] valueOfCard ] , [[self.rememberingDeck1 lastObject] kind]]];
        
        if( self.condition == 1){
            [self.ScorePlayerOne setText:[NSString stringWithFormat:@"Score: %ld", self.scorePlayerOneI + 1]];
            [self.ScorePlayerTwo setText:[NSString stringWithFormat:@"Score: %ld", self.scorePlayerTwoI - 1]];
        } else {
            [self.ScorePlayerOne setText:[NSString stringWithFormat:@"Score: %ld", self.scorePlayerOneI - 1]];
            [self.ScorePlayerTwo setText:[NSString stringWithFormat:@"Score: %ld", self.scorePlayerTwoI + 1]];
        }
        
    }
    else {
        [self makeDeck];
        [self shuffleDeck];
    }

    // --------------- Abonarea la notificarea AppDidEnterBackground ---------------- //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveStateOfTheGame:)
                                                 name:@"saveStateOfGame"
                                               object:nil];
    
    
    self.rememberingDeck1 = [NSMutableArray arrayWithCapacity:52];
    self.rememberingDeck2 = [NSMutableArray arrayWithCapacity:52];
    
}

    //      Crearea pachetului de carti (Deck)      //

- (void) makeDeck {
    

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

//      Amestecarea pachetului de carti si impartirea lui in doua jumatati egale        //

- (void) shuffleDeck {
    
    NSUInteger count = [self.Deck count];
    if (count > 1)
    {
        for (NSUInteger i = count - 1; i > 0; --i)
        {
            [self.Deck exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
        }
    }
    
    self.RandDeck  = [NSMutableArray arrayWithArray:self.Deck];
    self.PlayerOneDeck = [[NSMutableArray alloc] init];
    self.PlayerTwoDeck = [[NSMutableArray alloc] init];
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

// --------------- Salvarea datelor cu NSUserDefaults ---------------- //

- (void) saveStateOfTheGame: (NSNotification *)notification {
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.Deck] forKey: kDeckArrayKey];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.PlayerOneDeck] forKey: kStatePlayerOneKey];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.PlayerTwoDeck] forKey: kStatePlayerTwoKey];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.RandDeck] forKey: kDeckRandomKey];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.rememberingDeck1] forKey: kRememberDeck1Key];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.rememberingDeck2] forKey: kRememberDeck2Key];
    [userDefaults setInteger: self.numOfHands forKey:@"numOfHandsKey"];
    [userDefaults setInteger: self.handsWonbyPlayerOne forKey:@"handsWonByPlayerOneKey"];
    [userDefaults setInteger: self.handsWonbyPlayerTwo forKey:@"handsWonByPlayerTwoKey"];
    [userDefaults setInteger: self.scorePlayerOneI forKey:@"scoreP1k"];
    [userDefaults setInteger: self.scorePlayerTwoI forKey:@"scoreP2k"];
    [userDefaults setInteger: self.condition forKey:@"conditionKey"];
    [userDefaults setObject: self.forSegueCardOneKind forKey:@"forSegueCardOneKindKey"];
    [userDefaults setInteger: self.forSegueCardOneValue forKey:@"forSegueCardOneValueKey"];
    [userDefaults setObject: self.forSegueCardTwoKind forKey:@"forSegueCardTwoKindKey"];
    [userDefaults setInteger: self.forSegueCardTwoValue forKey:@"forSegueCardTwoValueKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

}

        // --------------- Metoda de recuperare a detelor din UserDefaults ---------------- //

- (void) retrieveStateGame {
    

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
    
    self.myObj = [userDefaults objectForKey:@"key1"];
    self.myObj2 = [userDefaults objectForKey:@"key2"];
    self.numOfHands = [userDefaults integerForKey:@"numOfHandsKey"];
    self.handsWonbyPlayerOne = [userDefaults integerForKey:@"handsWonByPlayerOneKey"];
    self.handsWonbyPlayerTwo = [userDefaults integerForKey:@"handsWonByPlayerTwoKey"];
    self.scorePlayerOneI = [userDefaults integerForKey:@"scoreP1k"];
    self.scorePlayerTwoI = [userDefaults integerForKey:@"scoreP2k"];
    self.condition = [userDefaults integerForKey:@"conditionKey"];
    self.forSegueCardOneKind = [userDefaults objectForKey:@"forSegueCardOneKindKey"];
    self.forSegueCardOneValue = [userDefaults integerForKey:@"forSegueCardOneValueKey"];
    self.forSegueCardTwoKind = [userDefaults objectForKey:@"forSegueCardTwoKindKey"];
    self.forSegueCardTwoValue = [userDefaults integerForKey:@"forSegueCardTwoValueKey"];
    
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
            self.condition = 1;
        }
        else if ([[self.PlayerOneDeck objectAtIndex:0] valueOfCard] > [[self.PlayerTwoDeck objectAtIndex:0] valueOfCard])
        {
            [self.rememberingDeck1 addObject:[self.PlayerOneDeck objectAtIndex:0]];
            [self.rememberingDeck2 addObject:[self.PlayerTwoDeck objectAtIndex:0]];
            [self.PlayerOneDeck addObject:[self.PlayerTwoDeck objectAtIndex:0]];
            [self.PlayerTwoDeck removeObjectAtIndex:0];
            [self.PlayerOneDeck addObject:[self.PlayerOneDeck objectAtIndex:0]];
            [self.PlayerOneDeck removeObjectAtIndex:0];
            self.handsWonbyPlayerTwo++;
            self.condition = 0;
        }
        else
        {
            self.WarButton.hidden = NO;
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
    self.scorePlayerOneI = [self.PlayerOneDeck count];
    self.scorePlayerTwoI = [self.PlayerTwoDeck count];
    self.forSegueCardOneKind = [[self.rememberingDeck1 lastObject] kind];
    self.forSegueCardOneValue = [[self.rememberingDeck1 lastObject] valueOfCard];
    self.forSegueCardTwoKind = [[self.rememberingDeck2 lastObject] kind];
    self.forSegueCardTwoValue = [[self.rememberingDeck2 lastObject] valueOfCard];
    
}

    //------------------------------- Butonul de reset al jocului -------------------------//

- (IBAction)resetGame:(id)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"keyDeckArray"];
    [userDefaults removeObjectForKey:@"keyDeckRandom"];
    [userDefaults removeObjectForKey:@"kForStateOfPlayerOneKey"];
    [userDefaults removeObjectForKey:@"kForStateOfPlayerTwoKey"];
    [userDefaults removeObjectForKey:@"kRememberDeck1Key"];
    [userDefaults removeObjectForKey:@"kRememberDeck2Key"];
    [userDefaults removeObjectForKey:@"key1"];
    [userDefaults removeObjectForKey:@"key2"];
    [userDefaults removeObjectForKey: @"kCondition"];
    [userDefaults synchronize];
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UINavigationController"];
    
    
    //------------------------------- Butonul de razboi al jocului -------------------------//
    
}
- (IBAction)WarButton:(id)sender {
    
    self.WarButton.hidden = YES;
    WarViewController *wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WarViewController"];
    wvc.playerOneWarDeck = self.PlayerOneDeck;
    wvc.playerTwoWarDeck = self.PlayerTwoDeck;
    wvc.playerOneName = playerOneNameLabel.text;
    wvc.playerTwoName = playerTwoNameLabel.text;
    wvc.navigationItem.title = @"WAR!";
    
    [self.navigationController pushViewController:wvc animated:YES];
}



@end
