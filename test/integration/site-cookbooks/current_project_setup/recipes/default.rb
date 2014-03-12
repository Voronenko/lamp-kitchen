include_recipe "database"

package 'libmysqlclient-dev'

gem_package "mysql" do
  options("--no-ri --no-rdoc")
end

mysql_connection_info = {
  :host => "localhost",
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

# drop if exists, then create a mysql database named viovendi
mysql_database 'devdb' do
  connection mysql_connection_info
  action [:drop, :create]
end




bash "import" do 
  cwd "/vagrant/public/www/sql_dump/"
  code <<-EOH

  mysql -u root -p#{node['mysql']['server_root_password']} devdb < /vagrant/public/www/sql_dump/initial_dump.sql	
  
  EOH
  action :run
end

package 'memcached'

package "php5-memcache" do
  action :install
end






