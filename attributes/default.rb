default['imagemagick']['install_method'] = "package"
default['imagemagick']['version'] = nil
default['imagemagick']['source']['url'] = "http://www.imagemagick.org/download/ImageMagick-#{node[:imagemagick][:version]}.tar.gz"
default['imagemagick']['source']['checksum'] = nil
