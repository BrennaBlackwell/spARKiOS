//
//  LogOutViewController.m
//  spARK
//
//  Created by Brenna on 12/3/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import "LogOutViewController.h"

@interface LogOutViewController ()

@end


@implementation LogOutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end