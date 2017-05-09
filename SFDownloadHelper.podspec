#
# Be sure to run `pod lib lint SFDownloadHelper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFDownloadHelper'
  s.version          = '0.1.0'
  s.summary          = '离线下载助手.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                离线下载助手&文件管理
                       DESC

  s.homepage         = 'https://github.com/Caiflower/SFDownloadHelper.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Caiflower' => 'caiflower20@163.com' }
  s.source           = { :git => 'https://github.com/Caiflower/SFDownloadHelper.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  # s.resource_bundles = {
  #   'SFDownloadHelper' => ['SFDownloadHelper/Assets/*.png']
  # }
  s.subspec 'SFFileHelper' do |fileHelper|
    fileHelper.source_files = 'SFDownloadHelper/Classes/FileHelper/*'
  end
  s.subspec 'DownloadHelper' do |downloadHelper|
    downloadHelper.source_files = 'SFDownloadHelper/Classes/downloadHelper/*'
    downloadHelper.dependency 'SFDownloadHelper/SFFileHelper'
  end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
