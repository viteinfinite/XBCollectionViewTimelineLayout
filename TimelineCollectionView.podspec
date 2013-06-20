Pod::Spec.new do |s|
  s.name         = "XBTimelineCollectionViewLayout"
  s.version      = "0.0.1"
  s.summary      = "XBTimelineCollectionViewLayout provides an UICollectionViewLayout with fixed row headers and column header allowing to display data in a timeline-like fashion"
  s.homepage     = "https://github.com/xebia-france/XBTimelineCollectionViewLayout"
  s.author       = { 'Simone Civetta' => 'viteinfinite@gmail.com' }

  s.license      = 'Apache License, Version 2.0'
  s.source       = { :git => "https://github.com/xebia-france/XBTimelineCollectionViewLayout.git", :tag => "0.0.1" }

  s.ios.deployment_target = '5.0'

  s.source_files = 'TimelineCollectionView/Layout/**/*.{h,m}'

  s.requires_arc = true

end
