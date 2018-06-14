require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|

  if Rails.env.production?
=begin
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY'],
      :region								 => 'us-west-1'
    }
    config.storage :fog
    config.fog_directory     =  ENV['S3_BUCKET']
=end
  else
    config.storage :file
  end
end
