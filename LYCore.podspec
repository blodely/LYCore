#
# Be sure to run `pod lib lint LYCore.podspec' to ensure this
# Created by Luo Yu(indie.luo@gmail.com)
#

Pod::Spec.new do |s|
	s.name             = 'LYCore'
	s.version          = '1.0.4'
	s.summary          = 'Core libs for iOS app.'

	s.description      = <<-DESC
Core library 4 iOS app.
                       DESC

	s.homepage         = 'https://github.com/blodely/LYCore'
	# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'Luo Yu' => 'indie.luo@gmail.com' }
	s.source           = { :git => 'https://github.com/blodely/LYCore.git', :tag => s.version.to_s }
	s.social_media_url = 'https://weibo.com/blodely'

	s.ios.deployment_target = '8.0'

	s.source_files = 'LYCore/Classes/network/*', 'LYCore/Classes/model/*', 'LYCore/Configuration/*.plist', 'LYCore/Classes/*' #'LYCore/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LYCore' => ['LYCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.frameworks = 'Foundation', 'UIKit'
  
  s.dependency 'AFNetworking', '~> 3.2.0'
  s.dependency 'FCFileManager', '~> 1.0.20'
  
  s.ios.dependency 'LYCategory'
  
end
