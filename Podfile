# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target '77DeckCards' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for 77DeckCards
	pod 'CenteredCollectionView'
  
  # Pods for TestPaypalApp
  pod 'PayPal-iOS-SDK', '~> 2.15'
  
  pod 'IQKeyboardManagerSwift' #for auto keyboard manage.
  pod 'NVActivityIndicatorView' #for show loader before web api result.
  pod 'SwiftMessages' # for show alert message from top middle bottom
  pod 'ReachabilitySwift' # for show network check
  pod 'Alamofire' # web api data request.
  
  pod 'SDWebImage', '~> 5.0'
  
  # Pods for FirebaseNotificationDemo
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  
end
# Workaround for Cocoapods issue #7606
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
