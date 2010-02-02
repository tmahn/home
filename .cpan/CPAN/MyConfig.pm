$CPAN::Config = {
         "auto_commit" => 0,
         "build_cache" => 10,
         "build_dir" => "$ENV{HOME}/.cpan/build",
         "cache_metadata" => 1,
         "cpan_home" => "$ENV{HOME}/.cpan",
         "ftp_proxy" => "$ENV{ftp_proxy}",
         "http_proxy" => "$ENV{http_proxy}",
         "index_expire" => 1,
         "keep_source_where" => "$ENV{HOME}/.cpan/sources",
         "make_arg" => "",
         "make_install_arg" => "",
         "makepl_arg" => "PREFIX=$ENV{HOME}/.perl",
         "mbuild_arg" => "",
         "mbuild_install_arg" => "",
         "mbuild_install_build_command" => "",
         "mbuildpl_arg" => "",
         "no_proxy" => "$ENV{no_proxy}",
         "prerequisites_policy" => "follow",
         "scan_cache" => "atstart",
         "connect_to_internet_ok" => 1,
         "urllist" => ["http://www.perl.com/CPAN"],
};
