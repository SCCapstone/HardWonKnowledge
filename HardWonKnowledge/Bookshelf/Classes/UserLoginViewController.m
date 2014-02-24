//
//  UserLoginViewController.m
//  Bookshelf
//
//  Created by Keneequa Brown on 2/20/14.
//
//

#import "UserLoginViewController.h"
#import "BookshelfGridViewController.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray* rows = [fileContents componentsSeparatedByString:@"\n"];
    
    userCredentials = [[NSMutableDictionary alloc] init];
    for (int n=0; n<[rows count]; n++){
        NSString* users = [rows objectAtIndex:n];
        NSArray* userInfo = [users componentsSeparatedByString:@" "];
        
        NSString *theUsername = [userInfo objectAtIndex:0];
        theUsername= [theUsername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        theUsername = [theUsername lowercaseString];
//        [usernameCredentials addObject:theUsername];
        NSString *thePassword = [userInfo objectAtIndex:1];
        thePassword = [thePassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        [passwordCredentials addObject:thePassword];
        [userCredentials setObject:thePassword forKey:theUsername];
//        [firstName addObject:[userInfo objectAtIndex:2]];
//        [lastName addObject:[userInfo objectAtIndex:3]];
    }
}

- (IBAction)userLogin{
    if([[userCredentials objectForKey:@"admin"]isEqualToString:passwordField.text]){
            // Sign in.
    }
    else if([[userCredentials objectForKey:usernameField.text]isEqualToString:passwordField.text]){
        BookshelfGridViewController *bookshelf = [[BookshelfGridViewController alloc] initWithNibName:nil bundle:nil];
        [self presentViewController:bookshelf animated:NO completion:NULL];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"Please enter a correct password/username combination." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

@end
