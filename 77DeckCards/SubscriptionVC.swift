//
//  SubscriptionVC.swift
//  77DeckCards
//
//  Created by Reena on 15/04/20.
//  Copyright © 2020 Creations. All rights reserved.
//

///in app purchase ...
//enum IAPHandlerAlertType{
//    case disabled
//    case restored
//    case purchased
//
//    func message() -> String{
//        switch self {
//        case .disabled: return "Purchases are disabled in your device!"
//        case .restored: return "You've successfully restored your purchase!"
//        case .purchased: return "You've successfully bought this purchase!"
//        }
//    }
//}



import UIKit

///in app purchase ...
//import StoreKit

class SubscriptionVC: UIViewController,PayPalPaymentDelegate//,SKProductsRequestDelegate
{
    
    ///in app purchase ...
//    var productsRequest = SKProductsRequest()
//    var validProducts = [SKProduct]()
//    var productIndex = 0
    
    
    /// paypal payment gateway....
    var environment:String = PayPalEnvironmentNoNetwork {
      willSet(newEnvironment) {
      if (newEnvironment != environment) {
      PayPalMobile.preconnect(withEnvironment: newEnvironment)
                  }
              }
          }
      var payPalConfig = PayPalConfiguration()
    
    
    @IBOutlet weak var ivBlurView: UIImageView!
    @IBOutlet weak var vSuccessMsg: UIView!
    
    
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ///in app purchase ...
     //   fetchAvailableProducts()
        
        
         /// paypal payment gateway....
        // Set up payPalConfig
              payPalConfig.acceptCreditCards = false
              payPalConfig.merchantName = "BREWIT 9"//Give your company name here.
              payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
              payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
              //This is the language in which your paypal sdk will be shown to users.
              payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
              //Here you can set the shipping address. You can choose either the address associated with PayPal account or different address. We’ll use .both here.
              payPalConfig.payPalShippingAddressOption = .both;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
           
         /// paypal payment gateway....
           environment = PayPalEnvironmentSandbox
       PayPalMobile.preconnect(withEnvironment: environment)
           }
    

    //MARK: - UIButton Action Methods.
    @IBAction func btnBackTapAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPremiumTapAction(_ sender: UIButton)
    {
        ///in app purchase ...
       // purchaseMyProduct(validProducts[productIndex])
        
        
         /// paypal payment gateway....
        //These are the items choosen by user, for example
               let item1 = PayPalItem(name: "Premium Plan", withQuantity: 1, withPrice: NSDecimalNumber(string: "9.99"), withCurrency: "USD", withSku: "Spirit-999")
             //  let item2 = PayPalItem(name: “Free rainbow patch”, withQuantity: 1, withPrice: NSDecimalNumber(string: “0.00”), withCurrency: “USD”, withSku: “Hip-00066”)
             //  let item3 = PayPalItem(name: “Long-sleeve plaid shirt (mustache not included)”, withQuantity: 1, withPrice: NSDecimalNumber(string: “37.99”), withCurrency: “USD”, withSku: “Hip-00291”)
               let items = [item1]//, item2, item3]
               let subtotal = PayPalItem.totalPrice(forItems: items) //This is the total price of all the items
               // Optional: include payment details
               let shipping = NSDecimalNumber(string: "0.0")
               let tax = NSDecimalNumber(string: "0.0")
               let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
               let total = subtotal.adding(shipping).adding(tax) //This is the total price including shipping and tax
               let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Premium Version", intent: .sale)
                       payment.items = items
                       payment.paymentDetails = paymentDetails
               if (payment.processable) {
               let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
               present(paymentViewController!, animated: true, completion: nil)
                       }
               else {
               // This particular payment will always be processable. If, for
               // example, the amount was negative or the shortDescription was
               // empty, this payment wouldn’t be processable, and you’d want
               // to handle that here.
               print("Payment not processalbe: (payment)")
                       }
        
    }
    
    @IBAction func btnRestorePurchaseTapAction(_ sender: UIButton)
    {
        ///in app purchase ...
       // restorePurchase()
    }
    
    
    //MARK: - Custom Methods.
    ///in app purchase ...
//    func fetchAvailableProducts()  {
//        let productIdentifiers = NSSet(objects:
//            "com.iap.100coins"        // 0
//
//        )
//
//        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
//        productsRequest.delegate = self
//        productsRequest.start()
//    }
//
//    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
//        if (response.products.count > 0) {
//            validProducts = response.products
//
//            let prod100coins = response.products[0] as SKProduct
//
//            print("1st rpoduct: " + prod100coins.localizedDescription)
//
//
//
//        }
//    }
//
//    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
//        return true
//    }
//
//    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
//
//    func purchaseMyProduct(_ product: SKProduct) {
//        if self.canMakePurchases() {
//            let payment = SKPayment(product: product)
//            SKPaymentQueue.default().add(self)
//            SKPaymentQueue.default().add(payment)
//        } else { print("Purchases are disabled in your device!") }
//    }
//
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//            for transaction:AnyObject in transactions {
//                if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
//                    switch trans.transactionState {
//
//                    case .purchased:
//                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                        if productIndex == 0 {
//                            print("You've bought 100 coins!")
//                           // buy100coinsButton.setTitle("Buy another 100 Coins Chest", for: .normal)
//                        }
//                        break
//
//                    case .failed:
//                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                        print("Payment has failed.")
//                        break
//                    case .restored:
//                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                        print("Purchase has been successfully restored!")
//                        break
//
//                    default: break
//            }}}
//    }
//
//    func restorePurchase() {
//            SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
//            SKPaymentQueue.default().restoreCompletedTransactions()
//    }
//
//    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//            print("The Payment was successfull!")
//    }
    
    
    
     /// paypal payment gateway....
    // PayPalPaymentDelegate
       func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
       print("PayPal Payment Cancelled")
               paymentViewController.dismiss(animated: true, completion: nil)
           }
       func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment)
       {
       print("PayPal Payment Success !")
               paymentViewController.dismiss(animated: true, completion: { () -> Void in
       // send completed confirmaion to your server
       print("Here is your proof of payment:nn(completedPayment.confirmation)nnSend this to your server for confirmation and fulfillment.")
                   })
        
        self.ivBlurView.isHidden = false
        self.vSuccessMsg.isHidden = false
        UIView.animate(withDuration: 2, delay: 0.5, options: UIView.AnimationOptions.transitionFlipFromTop, animations: {
            self.vSuccessMsg.alpha = 0
           
        }, completion: { finished in
            
             self.ivBlurView.isHidden = true
            self.vSuccessMsg.isHidden = true
            self.vSuccessMsg.alpha = 1
        })
        
        
           }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
