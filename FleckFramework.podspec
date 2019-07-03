#
# Be sure to run `pod lib lint FleckFramework.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FleckFramework'
  s.version          = '0.1.0'
  s.summary          = 'A short description of FleckFramework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Invisible1/FleckFramework'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tayyab AKSA' => 'software.developer93@gmail.com' }
  s.source           = { :git => 'https://github.com/Invisible1/FleckFramework.git' } #, :tag => s.version.to_s
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'FleckFramework/Classes/**/*'
  
  s.resource_bundles = {
    'FleckFramework' => ['FleckFramework/Classes/**/*.{storyboard,xib}']
  }
  s.requires_arc = true
  s.static_framework = true
  # s.resource_bundles = {
  #   'FleckFramework' => ['FleckFramework/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'AVFoundation', 'AssetsLibrary', 'opencv2'
  #s.pod_target_xcconfig = {'FRAMEWORK_SEARCH_PATHS' => '/Applications/Xcode_10.0.app/Contents/Developer/Library/Frameworks/'}
  #s.vendored_frameworks = 'opencv2.framework'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'OpenCV'
  # s.preserve_paths = '*.framework'
  s.pod_target_xcconfig = {'ENABLE_BITCODE' => 'NO','OTHER_LDFLAGS' => '-lObjC'}
  # s.vendored_frameworks = 'FleckFramework.framework'
  s.library = 'c++'

end
