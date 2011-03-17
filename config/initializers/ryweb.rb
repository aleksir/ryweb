require 'lib/htmldiff'

begin
  RYWEB = YAML.load_file("#{RAILS_ROOT}/config/ryweb.yml")
rescue
  puts "\nWARNING: config/ryweb.yml file not found. Copy defalt settings from config/ryweb.conf.example file\n"
end
