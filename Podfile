platform :ios, '11.0'

target 'TTKit' do
  use_frameworks!

  pod 'SwiftLint', '~> 0.29'

  pod 'RxSwift', '~> 4.4'
  pod 'RxSwiftExt', '~> 3.4'

  pod 'Alamofire', '~> 4.8'
  pod 'RxAlamofire', '~> 4.3'

  target 'TTKitTests' do
    inherit! :search_paths
  end
end

target 'TramTracker' do
  use_frameworks!

  pod 'RxCocoa', '~> 4.4'
  pod 'IQKeyboardManagerSwift', '~> 6.0'

  target 'TramTrackerTests' do
    inherit! :search_paths
  end

  target 'TramTrackerUITests' do
    inherit! :search_paths
  end
end
