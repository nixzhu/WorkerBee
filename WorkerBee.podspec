Pod::Spec.new do |s|

  s.name        = "WorkerBee"
  s.version     = "0.14.0"
  s.summary     = "WorkerBee is a toolkit"

  s.description = <<-DESC
                   WorkerBee as a toolkit has some functions and objects.
                   DESC

  s.homepage    = "https://github.com/nixzhu/WorkerBee"

  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.authors           = { "nixzhu" => "zhuhongxu@gmail.com" }
  s.social_media_url  = "https://twitter.com/nixzhu"

  s.ios.deployment_target   = "8.0"

  s.source          = { :git => "https://github.com/nixzhu/WorkerBee.git", :tag => s.version }
  s.source_files    = "WorkerBee/*.swift"
  s.requires_arc    = true

end
