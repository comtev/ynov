class nginx {
		package { 'nginx':
				ensure => present,
		}

		service { 'nginx':
				ensure     => running,
				enable     => true,
				hasrestart => true,
				hasstatus  => true,
				require    => Package['nginx'],
		}

		file { '/etc/nginx/sites-available/default':
				ensure  => file,
				mode    => '0644',
				source  => 'puppet:///modules/nginx/default',
				notify  => Service['nginx'],
				require => Package['nginx'],
		}

		file { '/etc/nginx/sites-enabled/default':
				ensure  => link,
				target  => '/etc/nginx/sites-available/default',
				require => File['/etc/nginx/sites-available/default'],
				notify  => Service['nginx'],
		}

		package { 'php5-fpm':
				ensure  => present,
				require => Package['nginx'],
		}

		service { 'php5-fpm':
				ensure     => running,
				enable     => true,
				hasrestart => true,
				hasstatus  => true,
				require    => Package['php5-fpm'],
		}

		file_line{ "disable pathinfo":
				path       => "/etc/php5/fpm/php.ini",
				line       => 'cgi.fix_pathinfo=0',
				require    => Package['php5-fpm'],
				notify     => Service['php5-fpm'],
		}

		file_line{ "make sure pathinfo is disabled":
				path       => "/etc/php5/fpm/php.ini",
				line       => 'cgi.fix_pathinfo=1',
				ensure     => 'absent',
				require    => Package['php5-fpm'],
				notify     => Service['php5-fpm'],
		}

		file { '/var/www/html/index.php':
				ensure  => file,
				mode    => '0777',
				source  => 'puppet:///modules/nginx/index.php',
				require => Package['nginx'],
		}

}