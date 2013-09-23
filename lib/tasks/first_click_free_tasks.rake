# desc "Explaining what the task does"
# task :first_click_free do
#   # Task goes here
# end

require 'open-uri'
require 'yaml'

namespace :first_click_free do

  desc "Update the list of domains permitted for first click free bypass
        from Google's list of supported domains"
  task :update_permitted_domains do
    File.open(File.join(FirstClickFree.root, 'config', 'domains.yml'), 'wb') do |domain_file|
      domains = open("http://www.google.com/supported_domains").read.split("\n")
      domains << ".bing.com"
      domains << ".yahoo.com"

      domain_file.write domains.to_yaml
      puts "Done. Wrote #{domains.length} domains to config/domains.yml"
    end
  end

end