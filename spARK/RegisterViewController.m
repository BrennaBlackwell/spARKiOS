//
//  RegisterViewController.m
//  spARK
//
//  Created by Brenna on 11/3/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end


@implementation RegisterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)textFieldReturn:(id)sender
{
	[sender resignFirstResponder];
}


- (IBAction)backgroundTouched:(id)sender
{
	[_usernameTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}


- (IBAction)registerButtonPressed
{
    NSString *usernameString = _usernameTextField.text;
    NSString *emailString = _emailTextField.text;
    NSString *passwordString = _passwordTextField.text;
    
    if ([usernameString isEqualToString:@""] || [emailString isEqualToString:@""] || [passwordString isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                        message:@"You need to enter all the values in order to register an account."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else
    {
        NSString *baseURLString = @"http://csce.uark.edu/~mmmcclel/spark/register.php?value1=";
        baseURLString = [baseURLString stringByAppendingFormat:@"%@&value2=%@&value3=%@", usernameString, emailString, passwordString];
        //NSLog(@"%@", baseURLString);
        
        NSURL *url;
        NSData *urlData;
        
        url = [NSURL URLWithString:baseURLString];
        urlData = [NSData dataWithContentsOfURL:url];
        
        if(urlData)
        {
            NSError *errorJSON = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:&errorJSON];
            NSLog(@"%@", json);
            
            if ([json isEqual:@"Success"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Created" message:@"Your account has been successfully created." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            else if ([json isEqual:@"UsernameTaken"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Creation Error" message:@"That username is taken. Please try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
}


@end