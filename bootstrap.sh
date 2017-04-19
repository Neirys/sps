# Setup the iOS project easy

echo "Welcome to the SPS bootstrap script"

if ! gem spec bundler > /dev/null 2>&1; then
  echo "Gem bundler is not installed! please run `gem install bundler` before runing this script"
  exit 0
fi

echo "Setup installation"
bundle config build.nokogiri --use-system-libraries=true —with-xml2-include=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/libxml2
echo "Install Gems"
bundle install --path vendor/bundle
echo "Install Pods the first sync can take time"
bundle exec pod install
