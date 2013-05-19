//
//  BraintreePhoneGapPlugin.m
//  BraintreePhoneGap
//
//  Created by Roman Punskyy on 18/05/2013.
//
//

#import "iOSBraintreePhoneGapPlugin.h"

@interface iOSBraintreePhoneGapPlugin ()
@property (nonatomic, strong) CDVInvokedUrlCommand *command;
@property (strong, nonatomic) BTPaymentViewController *paymentViewController;
- (void)paymentCancel:(id)sender;
@end

@implementation iOSBraintreePhoneGapPlugin

- (void)initWithSettings:(CDVInvokedUrlCommand *)command
{
  // check number of arguments, send error if not 5
  if ([command.arguments count] != 5) {
    NSString *errorMsg = [NSString stringWithFormat:@"There should be 5 arguments but %i was given !", command.arguments. count];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                      messageAsString:errorMsg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
  }
  
  // grab the parameters
  NSString *env = [command.arguments objectAtIndex:0];
  NSString *bt_sandbox_m_id = [command.arguments objectAtIndex:1];
  NSString *bt_sandbox_cs_enc_key = [command.arguments objectAtIndex:2];
  NSString *bt_production_cs_enc_key = [command.arguments objectAtIndex:3];
  NSString *bt_production_m_id = [command.arguments objectAtIndex:4];
  
  // initilise Venmo Touch framework depending on the environment
  if ([env isEqualToString:@"sandbox"]) {
    [VTClient
     startWithMerchantID:bt_sandbox_m_id
     braintreeClientSideEncryptionKey:bt_sandbox_cs_enc_key
     environment:VTEnvironmentSandbox];
  } else {
    [VTClient
     startWithMerchantID:bt_production_cs_enc_key
     braintreeClientSideEncryptionKey:bt_production_m_id
     environment:VTEnvironmentSandbox];
  }
  
  // send ok
  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  
}

- (void)paymentCancel:(id)sender
{
  // user pressed cancel
  // dismiss view and report to caller
  [self.viewController dismissViewControllerAnimated:YES completion:^{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
  }];
}

- (void)getCreditCardInfo:(CDVInvokedUrlCommand *)command
{
  // present braintree credit card controller
  self.command = command;
  self.paymentViewController = [BTPaymentViewController paymentViewControllerWithVenmoTouchEnabled:YES];
  self.paymentViewController.delegate = self;
  
  // check if zip entry show be shown or not
  BOOL showZip = NO;
  if ([command.arguments count]) {
    showZip = [[command.arguments objectAtIndex:0] boolValue];
  }
  self.paymentViewController.requestsZipInManualCardEntry = showZip;
  
  
  // Add paymentViewController to a navigation controller.
  UINavigationController *paymentNavigationController = [[UINavigationController alloc] initWithRootViewController:self.paymentViewController];
  
  // Add the cancel button
  self.paymentViewController.navigationItem.leftBarButtonItem =
  [[UIBarButtonItem alloc]
   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self
   action:@selector(paymentCancel:)];
  
  [self.viewController presentModalViewController:paymentNavigationController animated:YES];
}

- (void)dismiss:(CDVInvokedUrlCommand *)command
{
  // the developer needs to check if the credit card processes on the server or if he is happy with the data,
  // hence we need to export dismissing of the view
  [self.paymentViewController prepareForDismissal];
  [self.viewController dismissViewControllerAnimated:YES completion:^{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
  }];
}

#pragma mark - BTPaymentViewControllerDelegate

- (void)paymentViewController:(BTPaymentViewController *)paymentViewController
        didSubmitCardWithInfo:(NSDictionary *)cardInfo
         andCardInfoEncrypted:(NSDictionary *)cardInfoEncrypted
{
  // send credit card info to the caller
  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"cardInfo": cardInfo, @"cardInfoEncrypted": cardInfoEncrypted}];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
}



- (void)paymentViewController:(BTPaymentViewController *)paymentViewController
didAuthorizeCardWithPaymentMethodCode:(NSString *)paymentMethodCode
{
  // send credit card token to the caller
  NSDictionary *methodCode = @{@"venmo_sdk_payment_method_code": paymentMethodCode};
  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"token": methodCode}];
  
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
}




@end
