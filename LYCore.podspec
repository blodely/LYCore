#
# Be sure to run `pod lib lint LYCore.podspec' to ensure this
# Created by Luo Yu(indie.luo@gmail.com)
#

Pod::Spec.new do |s|
	s.name             = 'LYCore'
	s.version          = '1.13.4'
	s.summary          = 'Core libs for iOS app.'

	s.description      = <<-DESC
Core library 4 iOS app.
Versions: 1.0.38=>iOS8; 1.12.x=>Xcode12.iOS9
1.13.0: min=iOS11
1.13.1: add gradient control base view.
1.13.4: BIG CHANGE: from this version, core lib will move all base & custom views to LYFactAppCommon lib as dependency.
                       DESC

	s.homepage         = 'https://github.com/blodely/LYCore'
	# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'Luo Yu' => 'indie.luo@gmail.com' }
	s.source           = { :git => 'https://github.com/blodely/LYCore.git', :tag => s.version.to_s }
	s.social_media_url = 'https://weibo.com/blodely'

	s.ios.deployment_target = '11.0'

	s.source_files = 'LYCore/Classes/network/*', 'LYCore/Classes/model/*', 'LYCore/Classes/base_view/*', 'LYCore/Classes/feature_view/*', 'LYCore/Classes/viewc/*', 'LYCore/Classes/category/*', 'LYCore/Classes/*' #, 'LYCore/Configuration/*.plist', 'LYCore/Classes/**/*'
	
	s.resources = 'LYCore/Configuration/*.plist'
  
  # s.resource_bundles = {
  #   'LYCore' => ['LYCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit', 'CoreLocation'
  
  s.dependency 'AFNetworking', '~> 4.0'
  s.dependency 'FCFileManager', '~> 1.0.20'
  
  s.dependency 'LYCategory', '~> 1.13.6'
  s.dependency 'Masonry', '~> 1.1.0'
  
  s.dependency 'JLRoutes', '~> 2.1'
  
  s.dependency 'LYFactAppCommon'
  
end
