#
# Cookbook Name:: zenoss_build
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

product = node['zenoss_build']['build_flavor']
branch = node['zenoss_build']['branch']
repos = node['zenoss_build']['repos']



repos.each do |repo|
    subversion "zenoss repo" do
      Chef::Log.info("checking out #{repo}")
      repository repo
      revision branch
      destination "/home/zenoss/install-sources"
      action :sync
    end
end
