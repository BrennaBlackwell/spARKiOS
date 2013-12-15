//
//  ProfileViewController.m
//  spARK
//
//  Created by Brenna on 11/3/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end


@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated
{
    NSArray *userInfoArray = [[NSMutableArray alloc] initWithContentsOfFile:[self dataFilePath:(kLoginInfo)]];
    NSString *username = [userInfoArray objectAtIndex:0];
    _nameLabel.text = username;

    NSString *profileURLString = @"http://csce.uark.edu/~mmmcclel/spark/mycontent.php?value1=";
    profileURLString = [profileURLString stringByAppendingString:username];
    
    NSURL *profileURL = [NSURL URLWithString:profileURLString];
    NSData *urlData = [NSData dataWithContentsOfURL:profileURL];
    
    if (urlData)
    {
        NSError *errorJSON = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&errorJSON];
        NSString *successString = [[json objectForKey:@"success"] stringValue];
        
        if ([successString isEqualToString:@"1"])
        {
            _fullnameLabel.text = [json objectForKey:@"fullname"];
            _aboutLabel.text = [json objectForKey:@"description"];
        }
    }
}


- (NSString *)dataFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}


- (IBAction)editAccountButtonPressed:(id)sender
{
    EditProfileViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfile"];
    [self.navigationController pushViewController:newViewController animated:YES];
}


@end