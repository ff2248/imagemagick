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

src_filepath = "#{Chef::Config['file_cache_path']}/#{::File.basename(node['imagemagick']['source']['url'])}"
src_extractpath = "#{::File.dirname(src_filepath)}/#{::File.basename(src_filepath, ".tar.gz")}"

remote_file src_filepath do
  source   node['imagemagick']['source']['url']
  checksum node['imagemagick']['source']['checksum']
  backup   false

  not_if { ::File.exists?(src_filepath) }
end

execute "extract-source-imagemagick" do
  command "tar zxf #{src_filepath} -C #{::File.dirname(src_filepath)}"

  not_if { ::File.exists?(src_extractpath) }
end

execute "configure-imagemagick" do
  cwd src_extractpath
  command "./configure"
  notifies :run, "execute[make-imagemagick]", :immediately

  not_if "convert --version | grep #{node['imagemagick']['source']['version']}"
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
