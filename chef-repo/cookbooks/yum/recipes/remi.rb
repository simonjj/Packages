#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Cookbook Name:: yum
# Recipe:: epel
#
# Copyright:: Copyright (c) 2011 Opscode, Inc.
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
major = node['platform_version'].to_i
remi  = node['yum']['remi_release']

# If rpm installation from a URL supported 302's, we'd just use that.
# Instead, we get to remote_file then rpm_package.

remote_file "#{Chef::Config[:file_cache_path]}/remi-release-#{remi}.rpm" do
  Chef::Log.info("fetching into #{Chef::Config[:file_cache_path]}/remi-release-#{remi}.rpm to install soon")
  source "http://rpms.famillecollet.com/enterprise/remi-release-#{remi}.rpm"
  #source "http://download.fedoraproject.org/pub/epel/#{major}/i386/epel-release-#{epel}.noarch.rpm"
  not_if "rpm -qa | egrep -qx 'remi-release-#{remi}'"
  notifies :install, "rpm_package[remi-release]", :immediately
end

rpm_package "remi-release" do
  Chef::Log.info("installing remi rpm now...")
  source "#{Chef::Config[:file_cache_path]}/remi-release-#{remi}.rpm"
  only_if {::File.exists?("#{Chef::Config[:file_cache_path]}/remi-release-#{remi}.rpm")}
  action :nothing
end


file "remi-release-cleanup" do
  path "#{Chef::Config[:file_cache_path]}/remi-release-#{remi}.rpm"
  action :delete
end


#Enterprise Linux 6 (with EPEL)
#wget http://dl.fedoraproject.org/pub/epel/beta/6/i386/epel-release-6-5.noarch.rpm
#wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
#rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm

#Enterprise Linux 5 (with EPEL)
#wget http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
#wget http://rpms.famillecollet.com/enterprise/remi-release-5.rpm
#rpm -Uvh remi-release-5*.rpm epel-release-5*.rpm
