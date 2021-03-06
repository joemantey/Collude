/*
 *  Copyright (c) 2014, Parse, LLC. All rights reserved.
 *
 *  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
 *  copy, modify, and distribute this software in source code or binary form for use
 *  in connection with the web services and APIs provided by Parse.
 *
 *  As with any software that integrates with the Parse platform, your use of
 *  this software is subject to the Parse Terms of Service
 *  [https://www.parse.com/about/terms]. This copyright notice shall be
 *  included in all copies or substantial portions of the software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

#import "PFLogInViewController.h"

#import <Parse/PFTwitterUtils.h>

#import "PFActionButton.h"
#import "PFAlertView.h"
#import "PFPrimaryButton.h"
#import "PFSignUpViewController.h"
#import "PFTextField.h"

NSString *const PFLogInSuccessNotification = @"com.parse.ui.login.success";
NSString *const PFLogInFailureNotification = @"com.parse.ui.login.failure";
NSString *const PFLogInCancelNotification = @"com.parse.ui.login.cancel";

/*!
 This protocol exists so that we can weakly refer to messages to pass to PFFacebookUtils without
 actually taking a dependency on the symbols.
 */
@protocol WeaklyReferencedFBUtils

+ (void)logInWithPermissions:(NSArray *)permissions block:(void(^)(PFUser *user, NSError *error))block;

@end

@interface PFLogInViewController () {
    struct {
        BOOL shouldBeginLogIn : YES;
        BOOL didLogInUser : YES;
        BOOL didFailToLogIn : YES;
        BOOL didCancelLogIn : YES;
    } _delegateExistingMethods;
}

@property (nonatomic, strong, readwrite) PFLogInView *logInView;
@property (nonatomic, assign) BOOL loading;

@property (nonatomic, assign) CGFloat visibleKeyboardHeight;

@end

@implementation PFLogInViewController

#pragma mark -
#pragma mark NSObject

- (instancetype)init {
    if (self = [super init]) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit {
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    _fields = PFLogInFieldsDefault;

    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    // Unregister from all notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark UIViewController

- (void)loadView {
    _logInView = [[PFLogInView alloc] initWithFields:_fields];
    [_logInView setPresentingViewController:self];
    self.view = _logInView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupHandlers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self _registerForKeyboardNotifications];

    if (self.navigationController &&
        self.fields & PFLogInFieldsDismissButton) {
        self.fields = self.fields & ~PFLogInFieldsDismissButton;

        [_logInView.dismissButton removeFromSuperview];
    }
}

#pragma mark -
#pragma mark Rotation

- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    }

    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
#pragma mark PFLogInViewController

- (PFLogInView *)logInView {
    return (PFLogInView *)self.view; // self.view will call loadView if the view is nil
}

- (void)setEmailAsUsername:(BOOL)otherEmailAsUsername {
    self.logInView.emailAsUsername = otherEmailAsUsername;
}

- (BOOL)emailAsUsername {
    return self.logInView.emailAsUsername;
}

- (void)setDelegate:(id<PFLogInViewControllerDelegate>)delegate {
    if (self.delegate != delegate) {
        _delegate = delegate;

        _delegateExistingMethods.shouldBeginLogIn = [delegate respondsToSelector:@selector(logInViewController:
                                                                                           shouldBeginLogInWithUsername:
                                                                                           password:)];
        _delegateExistingMethods.didLogInUser = [delegate respondsToSelector:@selector(logInViewController:
                                                                                       didLogInUser:)];
        _delegateExistingMethods.didFailToLogIn = [delegate respondsToSelector:@selector(logInViewController:
                                                                                         didFailToLogInWithError:)];
        _delegateExistingMethods.didCancelLogIn = [delegate
                                                   respondsToSelector:@selector(logInViewControllerDidCancelLogIn:)];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _logInView.usernameField) {
        [_logInView.passwordField becomeFirstResponder];
    }
    if (textField == _logInView.passwordField) {
        [self _dismissKeyboard];
        [self _loginAction];
    }

    return YES;
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        NSString *email = [alertView textFieldAtIndex:0].text;
        [self _requestPasswordResetWithEmail:email];
    }
}

#pragma mark -
#pragma mark Private

- (void)setupHandlers {
    [_logInView.dismissButton addTarget:self
                                 action:@selector(_dismissAction)
                       forControlEvents:UIControlEventTouchUpInside];

    _logInView.usernameField.delegate = self;
    _logInView.passwordField.delegate = self;
    [_logInView.logInButton addTarget:self action:@selector(_loginAction) forControlEvents:UIControlEventTouchUpInside];
    [_logInView.passwordForgottenButton addTarget:self
                                           action:@selector(_forgotPasswordAction)
                                 forControlEvents:UIControlEventTouchUpInside];

    [_logInView.facebookButton addTarget:self
                                  action:@selector(_loginWithFacebook)
                        forControlEvents:UIControlEventTouchUpInside];
    [_logInView.twitterButton addTarget:self
                                 action:@selector(_loginWithTwitter)
                       forControlEvents:UIControlEventTouchUpInside];

    [_logInView.signUpButton addTarget:self
                                action:@selector(_signupAction)
                      forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(_dismissKeyboard)];
    [_logInView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)_dismissAction {
    [self cancelLogIn];

    // Normally the role of dismissing a modal controller lies on the presenting controller.
    // Here we violate the principle so that the presenting modal log in controller is especially easy.
    // Cons of this design is that it makes working with non-modally presented log in controller hard;
    // but this concern is mitigated by the fact that navigationally presented controller should not have
    // dismiss button.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_forgotPasswordAction {
    NSString *title = NSLocalizedString(@"Reset Password", @"Forgot password request title in PFLogInViewController");
    NSString *message = NSLocalizedString(@"Please enter the email address for your account.",
                                          @"Email request message in PFLogInViewController");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                              otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;

    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder = NSLocalizedString(@"Email", @"Email");
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.returnKeyType = UIReturnKeyDone;

    [alertView show];
}

- (void)_requestPasswordResetWithEmail:(NSString *)email {
    [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL success, NSError *error) {
        if (success) {
            NSString *title = NSLocalizedString(@"Password Reset",
                                                @"Password reset success alert title in PFLogInViewController.");
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"An email with reset instructions has been sent to '%@'.",
                                                                             @"Password reset message in PFLogInViewController"), email];
            [PFUIAlertView showAlertViewWithTitle:title
                                          message:message
                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")];
        } else {
            NSString *title = NSLocalizedString(@"Password Reset Failed",
                                                @"Password reset error alert title in PFLogInViewController.");
            [PFUIAlertView showAlertViewWithTitle:title error:error];
        }
    }];
}

- (void)_loginWithFacebook {
    if (self.loading) {
        return;
    }

    self.loading = YES;
    if ([_logInView.facebookButton isKindOfClass:[PFActionButton class]]) {
        [(PFActionButton *)_logInView.facebookButton setLoading:YES];
    }

    Class fbUtils = NSClassFromString(@"PFFacebookUtils");
    [fbUtils logInWithPermissions:_facebookPermissions block:^(PFUser *user, NSError *error) {
        self.loading = NO;
        if ([_logInView.facebookButton isKindOfClass:[PFActionButton class]]) {
            [(PFActionButton *)_logInView.facebookButton setLoading:NO];
        }

        if (user) {
            [self _loginDidSuceedWithUser:user];
        } else if (error) {
            [self _loginDidFailWithError:error];
        } else {
            // User cancelled login.
        }
    }];
}

- (void)_loginWithTwitter {
    if (self.loading) {
        return;
    }

    if ([_logInView.facebookButton isKindOfClass:[PFActionButton class]]) {
        [(PFActionButton *)_logInView.twitterButton setLoading:YES];
    }
    self.loading = YES;

    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        self.loading = NO;
        if ([_logInView.facebookButton isKindOfClass:[PFActionButton class]]) {
            [(PFActionButton *)_logInView.twitterButton setLoading:NO];
        }

        if (user) {
            [self _loginDidSuceedWithUser:user];
        } else if (error) {
            [self _loginDidFailWithError:error];
        } else {
            // User cancelled login.
        }
    }];
}

- (void)_loginAction {
    if (self.loading) {
        return;
    }

    NSString *username = _logInView.usernameField.text ?: @"";
    NSString *password = _logInView.passwordField.text ?: @"";

    if (_delegateExistingMethods.shouldBeginLogIn) {
        if (![_delegate logInViewController:self shouldBeginLogInWithUsername:username password:password]) {
            return;
        }
    }

    self.loading = YES;
    if ([_logInView.logInButton isKindOfClass:[PFPrimaryButton class]]) {
        [(PFActionButton *)_logInView.logInButton setLoading:YES];
    }

    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        self.loading = NO;
        if ([_logInView.logInButton isKindOfClass:[PFPrimaryButton class]]) {
            [(PFPrimaryButton *)_logInView.logInButton setLoading:NO];
        }

        if (user) {
            [self _loginDidSuceedWithUser:user];
        } else {
            [self _loginDidFailWithError:error];
        }
    }];
}

- (void)_signupAction {
    if (self.loading) {
        return;
    }
    [self presentViewController:self.signUpController animated:YES completion:nil];
}

- (void)_loginDidSuceedWithUser:(PFUser *)user {
    if (_delegateExistingMethods.didLogInUser) {
        [_delegate logInViewController:self didLogInUser:user];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PFLogInSuccessNotification object:self];
}

- (void)_loginDidFailWithError:(NSError *)error {
    if (_delegateExistingMethods.didFailToLogIn) {
        [_delegate logInViewController:self didFailToLogInWithError:error];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PFLogInFailureNotification object:self];

    NSString *title = NSLocalizedString(@"Login Error", @"Login error alert title in PFLogInViewController");
    [PFUIAlertView showAlertViewWithTitle:title error:error];
}

- (void)cancelLogIn {
    if (_delegateExistingMethods.didCancelLogIn) {
        [_delegate logInViewControllerDidCancelLogIn:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PFLogInCancelNotification object:self];
}

#pragma mark -
#pragma mark Accessors

- (PFSignUpViewController *)signUpController {
    if (!_signUpController) {
        _signUpController = [[PFSignUpViewController alloc] init];
        _signUpController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        _signUpController.emailAsUsername = self.emailAsUsername;
    }
    return _signUpController;
}

- (void)setLoading:(BOOL)loading {
    if (self.loading != loading) {
        _loading = loading;

        _logInView.usernameField.enabled = !self.loading;
        _logInView.passwordField.enabled = !self.loading;
        _logInView.passwordForgottenButton.enabled = !self.loading;
        _logInView.dismissButton.enabled = !self.loading;
    }
}

#pragma mark -
#pragma mark Keyboard

- (UIView *)currentFirstResponder {
    if ([_logInView.usernameField isFirstResponder]) {
        return _logInView.usernameField;
    }
    if ([_logInView.passwordField isFirstResponder]) {
        return _logInView.passwordField;
    }
    return nil;
}

- (void)_dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)_registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)_keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGRect keyboardFrame = [self.view convertRect:endFrame fromView:self.view.window];
    CGFloat visibleKeyboardHeight = CGRectGetMaxY(self.view.bounds) - CGRectGetMinY(keyboardFrame);

    [self setVisibleKeyboardHeight:visibleKeyboardHeight
                 animationDuration:duration
                  animationOptions:curve << 16];
}

- (void)_keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [self setVisibleKeyboardHeight:0.0
                 animationDuration:duration
                  animationOptions:curve << 16];
}

- (void)setVisibleKeyboardHeight:(CGFloat)visibleKeyboardHeight
               animationDuration:(NSTimeInterval)animationDuration
                animationOptions:(UIViewAnimationOptions)animationOptions {

    dispatch_block_t animationsBlock = ^{
        self.visibleKeyboardHeight = visibleKeyboardHeight;
    };

    if (animationDuration == 0.0) {
        animationsBlock();
    } else {
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:animationOptions | UIViewAnimationOptionBeginFromCurrentState
                         animations:animationsBlock
                         completion:nil];
    }
}

- (void)setVisibleKeyboardHeight:(CGFloat)visibleKeyboardHeight {
    if (self.visibleKeyboardHeight != visibleKeyboardHeight) {
        _visibleKeyboardHeight = visibleKeyboardHeight;
        [self _updateViewContentOffsetAnimated:NO];
    }
}

- (void)_updateViewContentOffsetAnimated:(BOOL)animated {
    CGPoint contentOffset = CGPointZero;
    if (self.visibleKeyboardHeight > 0.0f) {
        // Scroll the view to keep fields visible
        CGFloat offsetForScrollingTextFieldToTop = CGRectGetMinY([self currentFirstResponder].frame);

        UIView *lowestView;
        if (_logInView.passwordForgottenButton) {
            lowestView = _logInView.passwordForgottenButton;
        } else if (_logInView.logInButton) {
            lowestView = _logInView.logInButton;
        } else {
            lowestView = _logInView.passwordField;
        }

        CGFloat offsetForScrollingLowestViewToBottom = 0.0f;
        offsetForScrollingLowestViewToBottom += self.visibleKeyboardHeight;
        offsetForScrollingLowestViewToBottom += CGRectGetMaxY(lowestView.frame);
        offsetForScrollingLowestViewToBottom -= CGRectGetHeight(_logInView.bounds);

        if (offsetForScrollingLowestViewToBottom < 0) {
            return; // No scrolling required
        }

        contentOffset = CGPointMake(0.0f, MIN(offsetForScrollingTextFieldToTop,
                                              offsetForScrollingLowestViewToBottom));
    }

    [_logInView setContentOffset:contentOffset animated:animated];
}

@end
