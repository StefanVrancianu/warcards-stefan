//
//  SecondViewController.m
//  WarCards
//
//  Created by Stefan Vrancianu on 17/12/15.
//  Copyright © 2015 Stefan Vrancianu. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UILabel *handsPlayed;
@property (weak, nonatomic) IBOutlet UILabel *handsOwned;

@property (weak, nonatomic) IBOutlet UIImageView *currentCard;


@end

@implementation SecondViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.handsPlayed setText:[NSString stringWithFormat:@"%ld", self.ihandsPlayed]];
    [self.handsOwned setText:[NSString stringWithFormat:@"%ld", self.ihandsOwned]];
    self.currentCard.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld_%@", self.iValueToReceive, self.iKindToReceive]];
    
    
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

@end
