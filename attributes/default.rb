default['imagemagick']['install_method'] = "package"

default['imagemagick']['source']['version'] = node['imagemagick']['version'] || "7.0.1-6"
default['imagemagick']['source']['url'] = "http://www.imagemagick.org/download/ImageMagick-#{default[:imagemagick][:source][:version]}.tar.gz"
default['imagemagick']['source']['checksum'] = nil
