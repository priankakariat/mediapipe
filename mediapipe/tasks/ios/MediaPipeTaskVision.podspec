Pod::Spec.new do |s|
  s.name             = 'MediaPipeTaskVision'
  s.version          = '0.0.1'
  # '${MPP_BUILD_VERSION}'
  s.authors          = 'Google Inc.'
  s.license          = { :type => 'Apache',:file => "LICENSE" }
  s.homepage         = 'https://github.com/google/mediapipe'
  s.source           = { :http => 'https://dl.dropboxusercontent.com/s/qf3l3jb7zrjg87h/MediaPipeTaskVision-0.0.1.tar.gz' }
  ## '${MPP_DOWNLOAD_URL}'
  s.summary          = 'MediaPipe Task Library - Vision'
  s.description      = 'The Vision APIs of the MediaPipe Task Library'

  s.ios.deployment_target = '11.0'

  s.module_name = 'MediaPipeTaskVision'
  s.static_framework = true
  # s.user_target_xcconfig = {
  #   'OTHER_LDFLAGS' => '-all_load',
  # }
  s.libraries = "stdc++"
  s.library = 'c++'
  s.vendored_frameworks = 'frameworks/MediaPipeTaskVision.xcframework'
end