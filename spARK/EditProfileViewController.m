//
//  EditProfileViewController.m
//  spARK
//
//  Created by Brenna on 12/15/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()
{
    NSString *usernameString;
    NSString *userID;
}

@end


@implementation EditProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *userInfoArray = [[NSMutableArray alloc] initWithContentsOfFile:[self dataFilePath:(kLoginInfo)]];
    usernameString = [userInfoArray objectAtIndex:0];
    userID = [userInfoArray objectAtIndex:2];
    _usernameLabel.text = usernameString;
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


- (IBAction)saveButtonPressed:(id)sender
{
    NSString *nameString = _fullNameField.text;
    NSString *aboutString = _aboutField.text;
    
    if ((![nameString isEqualToString:@""]) && (![aboutString isEqualToString:@""]))
    {
        nameString = [nameString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        aboutString = [aboutString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *editProfileString = @"http://csce.uark.edu/~mmmcclel/spark/editprofile.php?value1=";
        editProfileString = [editProfileString stringByAppendingFormat:@"%@&value2=%@&vaue3=%@", userID, nameString, aboutString];
        
        NSURL *editURL = [NSURL URLWithString:editProfileString];
        NSData *urlData = [NSData dataWithContentsOfURL:editURL];
        
        if(urlData)
        {
            NSError *errorJSON = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&errorJSON];
            NSString *successString = [[json objectForKey:@"success"] stringValue];
            
            if ([successString isEqualToString:@"1"])
            {
                NSLog(@"Edit success");
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            else
            {
                NSLog(@"Edit fail");
            }
        }
        
    }
}


- (IBAction)backgroundTouched
{
    [_fullNameField resignFirstResponder];
    [_aboutField resignFirstResponder];
}


- (IBAction)textFieldReturn:(UITextField *)sender
{
    [sender resignFirstResponder];
}


@end