Description
===========

This cookbook provides the `remote_template` resource.
It's identical to the `template` resource, except the following caveeats:

* It takes the template from a remote source by HTTP/HTTPS
* It does not include the platform/host resolution, so the same template is used everywhere.

Compatibility
=============

The cookbook and resource has been tested with chef-client `10.12.0` and `11.4.0`. The code is based on chef-client 10 sources, but will be upgraded to the 11 style when Chef 11 will be more widespread.

Usage
=====

See the included example.rb recipe.

    remote_template "/tmp/hostname" do
      source "https://gist.github.com/labria/5177417/raw/88827c083969c63ab6a86010332147ed30bde5b9/hostname.erb"
      variables :hostname => node[:fqdn]
    end