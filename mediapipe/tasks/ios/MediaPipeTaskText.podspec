Pod::Spec.new do |s|
  s.name             = 'MediaPipeTaskText'
  s.version          = '2.0.7'
  # '${MPP_BUILD_VERSION}'
  s.authors          = 'Google Inc.'
  s.license          = { :type => 'Apache',:file => "LICENSE" }
  s.homepage         = 'https://github.com/google/mediapipe'
  s.source           = { :http => 'https://dl.dropboxusercontent.com/s/nl46ho09umbtnco/MediaPipeTaskText-2.0.0.tar.gz?dl=0' }
  ## '${MPP_DOWNLOAD_URL}'
  s.summary          = 'MediaPipe Task Library - Text'
  s.description      = 'The Natural Language APIs of the MediaPipe Task Library'

  s.ios.deployment_target = '11.0'

  s.module_name = 'MediaPipeTaskText'
  s.static_framework = true
  s.user_target_xcconfig = {
    'OTHER_LDFLAGS' => '-all_load',
  }

  s.library = 'c++'
  s.vendored_frameworks = 'frameworks/MediaPipeTaskText.xcframework'
end