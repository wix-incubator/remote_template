# Example recipe using a gist
remote_template "/tmp/hostname" do
  source "https://gist.github.com/labria/5177417/raw/88827c083969c63ab6a86010332147ed30bde5b9/hostname.erb"
  variables :hostname => node[:fqdn]
end
