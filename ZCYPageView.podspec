Pod::Spec.new do |s|

  s.name         = "ZCYPageView"
  s.version      = "0.0.3"
  s.summary      = "自定义PageView."
  s.homepage     = "https://github.com/ZhongChunYa/ZCYPageView"
  s.license      = "MIT"
  s.author       = { "MaginaZhong" => "719098083@qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/ZhongChunYa/ZCYPageView.git", :tag => "#{s.version}" }
  s.source_files = "ZCYPageView/ZCYPageView/*.swift"
  s.requires_arc = true
end
