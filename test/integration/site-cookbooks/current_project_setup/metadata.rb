name             "currentproject"
maintainer       "Vyacheslav Voronenko"
maintainer_email "git@voronenko.info"
license          "MIT"
description      "Demo project illustrating project related deployment recipes"
version          "0.0.1"

%w{ debian ubuntu }.each do |os|
supports os
end

depends           "apt"
depends           "apache2"
depends           "database"
depends           "git"
depends           "java"
depends           "mysql"
depends           "php"

