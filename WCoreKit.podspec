#
# Be sure to run `pod lib lint WCoreKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "WCoreKit"
  s.version          = "0.2.7"
  s.summary          = "一些方便开发的IOS工具类"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                       本人自己用的一些关于IOS开发的工具
                       DESC

  s.homepage         = "https://github.com/jw10126121/WCoreKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "linjw" => "10126121@qq.com" }
  s.source           = { :git => "https://github.com/jw10126121/WCoreKit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

#  s.frameworks = 'UIKit'
#  s.libraries = 'icucore'
#  s.source_files = 'Pod/Classes/**/*'
#  s.resource_bundles = {
#    'WCoreKit' => ['Pod/Assets/*.png']
#  }
# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 3.0'

    s.subspec 'WToolsKit' do |wToolsKit|
        wToolsKit.source_files = 'Pod/Classes/WToolsKit/**/*'
        wToolsKit.public_header_files = 'Pod/Classes/WToolsKit/**/*.h'
    end

    s.subspec 'WRuntimeKit' do |wRuntimeKit|
        wRuntimeKit.source_files = 'Pod/Classes/WRuntimeKit/**/*'
        wRuntimeKit.public_header_files = 'Pod/Classes/WRuntimeKit/**/*.h'
    end

    s.subspec 'WOrmManager' do |wOrmManager|
        wOrmManager.source_files = 'Pod/Classes/WOrmManager/**/*'
        wOrmManager.public_header_files = 'Pod/Classes/WOrmManager/**/*.h'
        wOrmManager.dependency 'WCoreKit/WRuntimeKit'
    end

    s.subspec 'WNavigationBarTool' do |sp|
       sp.source_files = 'Pod/Classes/WNavigationBarTool/**/*'
       sp.public_header_files = 'Pod/Classes/WNavigationBarTool/**/*.h'
    end

    s.subspec 'WImageBannerView' do |sp|
        sp.source_files = 'Pod/Classes/WImageBannerView/**/*'
        sp.public_header_files = 'Pod/Classes/WImageBannerView/**/*.h'
        sp.dependency 'SDWebImage'
        sp.dependency 'WCoreKit/WToolsKit'
    end

    s.subspec 'WServiceForDatabase' do |sp|
        sp.source_files = 'Pod/Classes/WServiceForDatabase/**/*'
        sp.public_header_files = 'Pod/Classes/WServiceForDatabase/**/*.h'
        sp.dependency 'WCoreKit/WOrmManager'
        sp.dependency 'FMDB'
    end


#    s.subspec 'WAuthorizationManager' do |sp|
#        sp.source_files = 'Pod/Classes/WAuthorizationManager/**/*'
#        sp.public_header_files = 'Pod/Classes/WAuthorizationManager/**/*.h'
#    end
#







end




