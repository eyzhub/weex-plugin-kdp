# coding: utf-8
Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
Pod::Spec.new do |s|
  s.name         = "WeexKdp"
  s.version      = "0.0.1"
  s.summary      = "Weex Plugin"

  s.description  = <<-DESC
                   Weexplugin Source Description
                   DESC

  s.homepage     = "https://github.com"
  s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
            copyright
    LICENSE
  }
  s.authors      = {
                     "Tiago Alves" =>"tralves@gmail.com"
                   }
  s.platform     = :ios
  s.ios.deployment_target = "9.0"

  s.source = { :git => "https://github.com/eyzhub/weex-kdp.git", :tag => s.version }
  s.source_files  = "ios/Sources/*.{h,m,mm}"

  s.requires_arc = true
  s.static_framework = true
  s.dependency "WeexPluginLoader"
  s.dependency "WeexSDK", "0.16.0"
  s.dependency "PlayKit"
end
