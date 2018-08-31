#
# Be sure to run `pod lib lint JingDataStateSwitch.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JingDataStateSwitch'
  s.version          = '0.1.0'
  s.summary          = '页面状态切换.'

  s.homepage         = 'https://github.com/tianziyao/JingDataStateSwitch'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tianziyao' => 'tianziyao@jingdata.com' }
  s.source           = { :git => 'https://github.com/tianziyao/JingDataStateSwitch.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'JingDataStateSwitch/Classes/**/*'
  
  s.resource_bundles = {
    'JingDataStateSwitch' => ['JingDataStateSwitch/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'JingDataPodResourceLoader'
end
