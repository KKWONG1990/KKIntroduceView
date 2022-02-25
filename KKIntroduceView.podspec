#
# Be sure to run `pod lib lint KKIntroduceView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KKIntroduceView'
  s.version          = '1.0.3'
  s.summary          = 'App介绍页、欢迎页视图'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  KKIntroduceView支持设置背景图，页面图片，标题，描述，按钮。可以通过代理方法设置标题描述按钮的样式，提供设置页面控件的位置大小代理方法，实现自定义位置大小。
                       DESC

  s.homepage         = 'https://github.com/KKWONG1990/KKIntroduceView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'KKWONG' => 'kkwong90@163.com' }
  s.source           = { :git => 'https://github.com/KKWONG1990/KKIntroduceView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'KKIntroduceView/Classes/**/*'
  
  #是否支持ARC
  s.requires_arc = true
  
  # s.resource_bundles = {
  #   'KKIntroduceView' => ['KKIntroduceView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
