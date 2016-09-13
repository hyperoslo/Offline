Pod::Spec.new do |s|
  s.name             = "Offline"
  s.summary          = "A short description of Offline."
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/hyperoslo/Offline"
  s.license          = 'MIT'
  s.author           = {
    "Hyper Interaktiv AS" => "ios@hyper.no"
  }
  s.source           = {
    :git => "https://github.com/hyperoslo/Offline.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/hyperoslo'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.2'

  s.requires_arc = true
  s.source_files = 'Sources/**/*'
  s.frameworks = 'Foundation'
end
