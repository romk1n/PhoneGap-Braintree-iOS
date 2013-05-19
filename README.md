Braintree iOS plug-in for Phone Gap
---------------------------------

Plugin to use native Braintree SDK within PhoneGap framework projects

Integration instructions
------------------------
1. Add `iOSBraintreePhoneGapPlugin.[h|m]` to your project (Plugins group).  
2. Copy `BrainTreePayment.js` to your project's `www` folder   
3. Add the following to your `config.xml`:  
`<plugin name="BraintreePlugin" value="iOSBraintreePhoneGapPlugin" />`

### EXAMPLE JS

```
function callWebService(){

    
    var BTPayment = window.plugins.btreeplugin;
    
    BTPayment.getCardInfo(onGetCardInfoSuccess,onGetCardInfoError);

    function onGetCardInfoSuccess (successObject) {

        
        var cardData;
        
        // Verifying is we got encrypted card infor or token
        //
        if (successObject.cardInfoEncrypted) {
          cardData = successObject.cardInfoEncrypted;
        } else if (successObject.token) {
          cardData = successObject.token;
        } else {
  		// do something
        }
        
        // Communicating with the remote server
        //
        $.post("your endpoint", cardData, function(data) {
          console.log('server returned sucess' + JSON.stringify(data));

        // Received response from Braintree servers
        // now can dismiss the view
        BTPayment.dismiss();

    };

    function onGetCardInfoError (errorObject) {
         console.log('onGetCardInfoError: ' + errorObject);

    };
    
}
```
