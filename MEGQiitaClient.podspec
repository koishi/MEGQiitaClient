Pod::Spec.new do |s|
  s.name          = 'MEGQiitaClient'
  s.version       = '0.0.1'
  s.license       = 'standard 2-clause BSD license'
  s.summary       = ''
  s.homepage      = 'https://github.com/koishi/MEGQiitaClient.git'
  s.author        = 'https://github.com/koishi/MEGQiitaClient'
  s.source        = { :git => "https://github.com/koishi/MEGQiitaClient.git", :tag => "#{s.version}"}
  s.source_files  = 'Core'
  s.requires_arc = true
  s.platform = :ios, '7.0'
  s.dependency 'AFNetworking'
  s.dependency 'UICKeyChainStore'
end
