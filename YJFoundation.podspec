Pod::Spec.new do |s|

  s.name         = "YJFoundation"
  s.version      = "1.0.11"
  s.summary      = "YJFoundation of iOS"
  s.homepage     = "https://github.com/MOyejin/YJFoundation"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "MOyejin" => "1976779764@qq.com" }
  s.platform     = :ios, '9.0'
  s.source       = { :git => "https://github.com/MOyejin/YJFoundation.git", :tag => "#{s.version}" }
  s.source_files = "YJFoundation", "YJFoundation/**/*.{h,m}"


end
