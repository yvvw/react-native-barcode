require 'json'

package_json = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name                = 'RNLBarCode'
  s.version             = package_json["version"]
  s.author              = { package_json['author']['name'] => package_json['author']['email'] }
  s.license             = { :type => package_json['license'] }
  s.homepage            = package_json['homepage']
  s.source              = { :git => package_json['repository']['url'], :tag => "v#{package_json['version']}" }
  s.summary             = package_json['description']

  s.platform            = :ios, '8.0'
  s.source_files        = 'ios/*.{h,m}'
  s.dependency 'React'
  s.dependency 'ZBarSDK', '~> 1.3'
end
