#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint oneconnect_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'oneconnect_flutter'
  s.version          = '0.0.2'
  s.summary          = 'OneConnect for flutter'
  s.description      = <<-DESC
OpenVPN for flutter
                       DESC
  s.homepage         = 'http://oneconnect.top'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'OneConnect' => 'support@oneconnect.top' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
