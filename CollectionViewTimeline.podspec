Pod::Spec.new do |s|
  s.name         = "XBCollectionViewTimelineLayout"
  s.version      = "0.0.1"
  s.summary      = "XBCollectionViewTimelineLayout provides an UICollectionViewLayout with fixed row headers and column header allowing to display data in a timeline-like fashion"
  s.homepage     = "https://github.com/xebia-france/XBCollectionViewTimelineLayout"
  s.author       = { 'Simone Civetta' => 'viteinfinite@gmail.com' }

  s.license      = 'Apache License, Version 2.0'
  s.source       = { :git => "https://github.com/viteinfinite/XBCollectionViewTimelineLayout.git", :tag => "0.0.1" }

  s.ios.deployment_target = '5.0'

  s.source_files = 'TimelineCollectionView/Layout/**/*.{h,m}'

  s.requires_arc = true

  s.dependency 'PSTCollectionView',  '~> 1.0.0'

end
