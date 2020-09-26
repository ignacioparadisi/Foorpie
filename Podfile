# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

def common_pods
  # Pods for Foorpie
  pod 'GoogleSignIn'
end

target 'Foorpie' do
  common_pods
end

target 'Foorpie Local' do
  common_pods
end

target 'Foorpie Staging' do
  common_pods
  
  target 'FoorpieTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FoorpieUITests' do
    # Pods for testing
  end
end

