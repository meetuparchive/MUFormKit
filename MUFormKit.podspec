#
#  Be sure to run `pod spec lint MUFormKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MUFormKit"
  s.authors      = "Meetup"
  s.homepage     = "http://github.com/meetup"
  s.version      = "0.0.1"
  s.summary      = "A framework for making forms"
  s.license      = "MIT"
  s.platform     = :ios
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "git@github.com:meetup/MUFormKit.git", :tag => "0.0.1" }
  s.source_files  = ["src/Classes","src/Resources/*"]
  s.resources = ["src/Resources/**/*.xib"]
  s.frameworks = "Foundation", "CoreGraphics", "CoreData", "UIKit"
  s.dependency "MUCore"
  s.dependency "SAMTextView"
  s.requires_arc = true

end
