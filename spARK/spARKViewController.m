//
//  spARKViewController.m
//  spARK
//
//  Created by Brenna Blackwell on 10/24/13.
//  Copyright (c) 2013 brennablackwell.com. All rights reserved.
//

#import "spARKViewController.h"

@interface spARKViewController ()
{
    NSMutableArray *logInArray;
    NSString *filePath;
    BOOL logInExists;
    BOOL logOut;
}

@end

@implementation spARKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    logInArray = [[NSMutableArray alloc] init];
    logInExists = NO;
    logOut = NO;
    filePath = [self dataFilePath:(kLoginInfo)];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        logInExists = YES;
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    if (logInExists)
    {
        logInArray = [[NSMutableArray alloc] initWithContentsOfFile:[self dataFilePath:(kLoginInfo)]];
        
        NSString *username = [logInArray objectAtIndex:0];
        NSString *password = [logInArray objectAtIndex:1];
        
        _usernameTextField.text = username;
        _passwordTextField.text = password;
        
        if (!logOut)
        {
            [self logInButtonPressed];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSString *)dataFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}


- (IBAction)textFieldReturn:(id)sender
{
	[sender resignFirstResponder];
}


- (IBAction)backgroundTouched:(id)sender
{
	[_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}


- (IBAction)logInButtonPressed
{
    NSString *usernameString = _usernameTextField.text;
    NSString *passwordString = _passwordTextField.text;
    
    logOut = NO;
    
    if ([usernameString isEqualToString:@""] || [passwordString isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                        message:@"You need to enter a username and password to log in."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else
    {
        logOut = YES;
        
        NSString *baseURLString = @"http://csce.uark.edu/~mmmcclel/spark/authentication.php?value1=";
        baseURLString = [baseURLString stringByAppendingFormat:@"%@&value2=%@", usernameString, passwordString];
        
        NSURL *url;
        NSData *urlData;
        
        url = [NSURL URLWithString:baseURLString];
        urlData = [NSData dataWithContentsOfURL:url];
        
        if(urlData)
        {
            NSError *errorJSON = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&errorJSON];
            NSString *successString = [[json objectForKey:@"success"] stringValue];

            if ([successString isEqualToString:@"1"])
            {
                NSString *contentString = @"http://csce.uark.edu/~mmmcclel/spark/mycontent.php?value1=";
                contentString = [contentString stringByAppendingString:usernameString];
                NSURL *contentURL = [NSURL URLWithString:contentString];
                NSData *contentURLData = [NSData dataWithContentsOfURL:contentURL];
                NSError *contentError = nil;
                NSDictionary *contentDictionary = [NSJSONSerialization JSONObjectWithData:contentURLData options:kNilOptions error:&contentError];
                NSString *userID = [contentDictionary objectForKey:@"userid"];
                
                [logInArray removeAllObjects];
                [logInArray addObject:usernameString];
                [logInArray addObject:passwordString];
                [logInArray addObject:userID];
                [logInArray writeToFile:[self dataFilePath:(kLoginInfo)] atomically:YES];
                
                SWRevealViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Reveal"];
                [self presentViewController:newViewController animated:YES completion:nil];
            }
        }
    }
}


@end