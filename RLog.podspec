Pod::Spec.new do |s|
  s.name             = "RLog"
  s.version          = "1.0.0"
  s.summary          = "Simple & efficient logging library in Objective-C."
  s.homepage         = "https://github.com/GDXRepo/RLog"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Georgiy Malyukov" => "" }
  s.source           = { :git => "https://github.com/GDXRepo/RLog.git", :tag => s.version.to_s }
  s.social_media_url = 'http://deadlineru.livejournal.com'

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
end
