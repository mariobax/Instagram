//
//  LoginViewController.m
//  Instagram
//
//  Created by mariobaxter on 7/8/19.
//  Copyright © 2019 mariobaxter. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Parse/PFUser.h"
 #include <math.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthTopConstraint;
@property float viewHeight;
@property float multiplier;
@property (weak, nonatomic) IBOutlet UILabel *miscellaneousLabel;

@end

@implementation LoginViewController

// This method does not allow the view controller to flip to landscape mode.
-(void) restrictRotation:(BOOL) restriction {
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    appDelegate.restrictRotation = restriction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.clipsToBounds = YES;
    self.signupButton.layer.cornerRadius = 5;
    self.signupButton.clipsToBounds = YES;
    self.usernameTextField.alpha = 0;
    
    [self restrictRotation:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.viewHeight = self.view.frame.size.height;
    self.multiplier = 570;
    NSLog(@"%f", self.viewHeight);
}

-(void) liftElements {
    [UIView animateWithDuration:0.5 animations:^{
        self.topConstraint.constant -= (70000.0*self.multiplier)/pow(self.viewHeight, 2); //140;
        self.imageTopConstraint.constant -= (30000.0*self.multiplier)/pow(self.viewHeight, 2); //80;
        self.secondTopConstraint.constant -= (10000.0*self.multiplier)/pow(self.viewHeight, 2); //10
        self.thirdTopConstraint.constant -= (10000.0*self.multiplier)/pow(self.viewHeight, 2); //10
        self.fourthTopConstraint.constant -= (10000.0*self.multiplier)/pow(self.viewHeight, 2); //10
        [self.view layoutIfNeeded];
    }];
}

-(void) lowerElements {
    [UIView animateWithDuration:0.5 animations:^{
        self.topConstraint.constant +=(70000.0*self.multiplier)/pow(self.viewHeight, 2); //140;
        self.imageTopConstraint.constant += (30000.0*self.multiplier)/pow(self.viewHeight, 2); //80;
        self.secondTopConstraint.constant += (10000.0*self.multiplier)/pow(self.viewHeight, 2); //10
        self.thirdTopConstraint.constant += (10000.0*self.multiplier)/pow(self.viewHeight, 2); //10
        self.fourthTopConstraint.constant += (10000.0*self.multiplier)/pow(self.viewHeight, 2); //10
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)emailIsEditing:(id)sender {
    [self liftElements];
}

- (IBAction)emailFinishedEditing:(id)sender {
    [self lowerElements];
}

- (IBAction)passwordIsEditing:(id)sender {
    [self liftElements];
}

- (IBAction)passwordFinishedEditing:(id)sender {
    [self lowerElements];
}

- (IBAction)usernameIsEditing:(id)sender {
    [self liftElements];
}

- (IBAction)usernameFinishedEditing:(id)sender {
    [self lowerElements];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    // set user properties
    newUser.username = self.usernameTextField.text;
    //newUser.email = self.emailField.text;
    newUser.password = self.passwordTextField.text;

    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");

            // manually segue to logged in view
        }
    }];
}

- (void)loginUser {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
        }
    }];
}

- (IBAction)loginPressed:(id)sender {
    // If log in
    if (self.usernameTextField.alpha == 0) {
        NSLog(@"Logging in...");
        [self loginUser];
    } else { // If Sign up
        NSLog(@"Signing up...");
        [self registerUser];
    }
}

- (IBAction)signupPressed:(id)sender {
    if (self.usernameTextField.alpha == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.emailTextField setPlaceholder:@"Email"];
            [self.loginButton setTitle:@"Sign Up" forState:UIControlStateNormal];
            [self.miscellaneousLabel setText:@""];
            [self.signupButton setTitle:@"Back to Log In" forState:UIControlStateNormal];
            self.usernameTextField.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            [self.emailTextField setPlaceholder:@"Username or Email"];
            [self.miscellaneousLabel setText:@"Don't have an account?"];
            self.usernameTextField.alpha = 0;
            [self.signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
             [self.loginButton setTitle:@"Log In" forState:UIControlStateNormal];
        }];
    }
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
