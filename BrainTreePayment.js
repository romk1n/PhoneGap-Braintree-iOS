/*
* PhoneGap plugin for BrainTree payments
* BrainTreePayment.js
*
*
* by Saul Zukauskas @sauliuz 
* PopularOwl Labs // www.popularowl.com
* @18.05.2013
*/


// constructor
//
function BrainTreePayment () {
	console.log('Construct');

}

// init with environment variables
//
BrainTreePayment.prototype.init = function(env,sandbox_mid, sandbox_encription_key, production_mid, production_encription_key, onSuccess, onFailure)
{

	environment = env || "";
	sandbox_merchant_id = sandbox_mid || "";
	production_merchant_id = production_mid || "";
	s_encription_key = sandbox_encription_key || "";
	p_encription_key = production_encription_key || "";

	cordova.exec(function(){console.log('Init success ');},null,"BraintreePlugin","initWithSettings", [environment, sandbox_merchant_id, sandbox_encription_key, production_merchant_id, p_encription_key]);

    // Log
    //
    console.log('BrainTreePayment.init done');

};

// Get card info asks Braintree library to return encrypted card info or token id card is saved
//
BrainTreePayment.prototype.getCardInfo = function(successCallback, failureCallback)
{
    cordova.exec(successCallback, failureCallback, "BraintreePlugin", "getCreditCardInfo", [])
    console.log('BrainTreePayment.getCardInfoz done');
};


// Dismisses Braintree dialog window if developer no more needs it
//
BrainTreePayment.prototype.dismiss = function(successCallback, failureCallback)
{
	cordova.exec(successCallback, failureCallback, "BraintreePlugin", "dismiss", [])
    console.log('Dismiss!!');
};

// Constructor makes all methods in this file accesible
// to JavaScript in PhoneGap application
//
cordova.addConstructor(function() {
  if(!window.plugins) {
    window.plugins = {};
  }
  if(!window.plugins.btreeplugin) {
    window.plugins.btreeplugin = new BrainTreePayment();
  }
});