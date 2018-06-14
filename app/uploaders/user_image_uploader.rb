class UserImageUploader < CarrierWave::Uploader::Base
  version :thumb do
    process resize_to_fill: [300, 300]
  end
end
