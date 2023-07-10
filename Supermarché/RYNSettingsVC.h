//
//  RYNSettingsVC.h
//  Supermarché
//
//  Created by Ryan McNulty on 19/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYNSettingsVC : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *shopMemSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *priceCompSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoremovalSwitch;

- (IBAction)priceCompSwitchToggled:(id)sender;
- (IBAction)shopMemSwitchToggled:(id)sender;
- (IBAction)autoremovalSwitchToggled:(id)sender;

@end
