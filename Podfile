# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ledgr' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ledgr
  pod 'RealmSwift', '~> 3.20.0'
  pod 'SnapKit'
  pod 'SwifterSwift'
  pod 'AFDateHelper'
  pod 'FormToolbar', :git => 'https://github.com/carleihar/FormToolbar'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'

  target 'ledgrTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end

  target 'ledgrUITests' do
    inherit! :complete
  end

end
