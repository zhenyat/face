################################################################################
#   Gets data from yml-file
#   
#   NB! Rails.root is not defined yet
#
#   21.07.2017  ZT
#   10.11.2017  Updated to handle secrets (new methods added)
#   07.02.2018  Credentials handling added (5.2) vs secrets at 5.1
#   22.04.2022  Ruby 3 / Rails 7
################################################################################
module Face
  if defined?(Rails).nil?   # While testing the Gem
    begin
      gem_root = `pwd`.chomp
      config_file = YAML.load_file(File.join(gem_root, "config", "face.yml"))
      DOMAIN = config_file['domain'].freeze
      KEY    = config_file['key'].freeze
      SECRET = config_file['secret'].freeze
      
    rescue Errno::ENOENT => e
      puts colored(RED, "Could not parse YAML-file: #{e.message}")
      exit
    end
  end

  def self.get_domain
    if const_defined?('DOMAIN')
      DOMAIN
    else
      Rails.application.credentials.config[:domain]
    end
  end

  def self.get_key
    if const_defined?('KEY')
      KEY
    else
      Rails.application.credentials.config[:api_key]
    end
  end
  
  def self.get_secret
    if const_defined?('SECRET')
      SECRET
    else
      Rails.application.credentials.config[:api_secret]
    end
  end
end