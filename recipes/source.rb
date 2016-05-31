#
# Cookbook Name:: imagemagick
# Recipe:: source
#
# Copyright 2009, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

source_url = if node['imagemagick']['version']
               node['imagemagick']['source']['url']
             else
               "http://www.imagemagick.org/download/ImageMagick.tar.gz"
             end

src_filepath = "#{Chef::Config['file_cache_path']}/#{::File.basename(source_url)}"
src_extractpath = "#{::File.dirname(src_filepath)}/#{::File.basename(src_filepath, ".tar.gz")}"

remote_file src_filepath do
  source   source_url
  checksum node['imagemagick']['source']['checksum']
  backup   false

  not_if { ::File.exists?(src_filepath) }
end

directory "mkdir-imagemagick" do
  path src_extractpath
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :run, "execute[extract-source-imagemagick]", :immediately

  not_if { ::File.exists?(src_extractpath) }
end

execute "extract-source-imagemagick" do
  command "tar zxf #{src_filepath} --strip-components 1 -C #{src_extractpath}"

  action :nothing
end

execute "configure-imagemagick" do
  cwd src_extractpath
  command "./configure"
  notifies :run, "execute[make-imagemagick]", :immediately

  if node['imagemagick']['version']
    not_if "convert --version | grep #{node['imagemagick']['version']}"
  else
    not_if "which convert"
  end
end

execute "make-imagemagick" do
  cwd src_extractpath
  command "make"
  action :nothing
  notifies :run, "execute[install-imagemagick]", :immediately
end

execute "install-imagemagick" do
  cwd src_extractpath
  command "make install"
  action :nothing
  notifies :run, "execute[ldconfig-imagemagick]", :immediately
end

execute "ldconfig-imagemagick" do
  command "ldconfig /usr/local/lib"
  action :nothing
end
