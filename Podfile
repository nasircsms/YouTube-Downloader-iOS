platform :ios, '13.0'
use_frameworks!

target ‘YouTubeVideoDownloader’ do
   
pod 'Alamofire'
pod 'TFHpple'
pod 'WKWebViewWithURLProtocol'
pod 'GCDWebServer'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            configuration.build_settings['SWIFT_VERSION'] = "4.0"
        end
    end
end
end
