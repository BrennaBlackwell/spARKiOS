//
//  CommentViewController.m
//  spARK
//
//  Created by Brenna on 12/9/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end


@implementation CommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    _commentsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_originalDiscussion.comments count]; i++)
    {
        NSDictionary *comment = [_originalDiscussion.comments objectAtIndex:i];
        //NSLog(@"%@", comment);
        
        [_commentsArray addObject:[NewsFeedObject
                                     newNewsFeedObjectWithID:[comment objectForKey:@"id"]
                                     withTitle:[comment objectForKey:@"title"]
                                     withPostTime:[comment objectForKey:@"timestamp"]
                                     withUser:[comment objectForKey:@"username"]
                                     withUserID:[comment objectForKey:@"userid"]
                                     withMessage:[comment objectForKey:@"body"]
                                     withUserImage:[comment objectForKey:@""]
                                     withLatitude:[comment objectForKey:@"latitude"]
                                     withLongitude:[comment objectForKey:@"longitude"]
                                     withRating:[comment objectForKey:@"user_rating"]
                                     withRatingFlag:[comment objectForKey:@"user_rating_flag"]]];
    }
    
    [_tableView reloadData];
    
    _titleLabel.text = _originalDiscussion.titleString;
    _messageTextView.text = _originalDiscussion.messageString;
    _timePostedLabel.text = _originalDiscussion.timePostedString;
    _usernameLabel.text = _originalDiscussion.usernameString;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)keyboardWillShow:(NSNotification*)aNotification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = [[self view] frame];
    rect.origin.y -= 210;
    [[self view] setFrame: rect];
	[UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification*)aNotification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = [[self view] frame];
    rect.origin.y += 210;
    [[self view] setFrame: rect];
	[UIView commitAnimations];
}


- (void)hideKeyboard
{
    [_submitCommentTextField resignFirstResponder];
}


- (NSString *)dataFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}


- (IBAction)submitButtonPressed:(id)sender
{
    NSArray *userInfoArray = [[NSMutableArray alloc] initWithContentsOfFile:[self dataFilePath:(kLoginInfo)]];
    NSString *userID = [userInfoArray objectAtIndex:2];
    NSString *discussionID = _originalDiscussion.idString;
    NSString *messageString = _submitCommentTextField.text;
    
    if (![messageString isEqualToString:@""])
    {
        messageString = [messageString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        
        NSString *baseURLString = @"http://csce.uark.edu/~mmmcclel/spark/postcomment.php?value1=";
        baseURLString = [baseURLString stringByAppendingFormat:@"%@&value2=%@&value3=%@", userID, discussionID, messageString];
        
        NSURL *commentURL = [NSURL URLWithString:baseURLString];
        NSData *urlData = [NSData dataWithContentsOfURL:commentURL];
        
        if(urlData)
        {
            NSError *errorJSON = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&errorJSON];
            NSString *successString = [[json objectForKey:@"success"] stringValue];
            
            if ([successString isEqualToString:@"1"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    NewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NewsFeedObject *objectToDisplay = [_commentsArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = objectToDisplay.titleString;
    cell.messageTextView.text = objectToDisplay.messageString;
    cell.timePostedLabel.text = objectToDisplay.timePostedString;
    cell.usernameLabel.text = objectToDisplay.usernameString;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (IBAction)backgroundTouched
{
    [_submitCommentTextField resignFirstResponder];
}


- (IBAction)textFieldReturn:(UITextField *)sender
{
    [sender resignFirstResponder];
}


@end