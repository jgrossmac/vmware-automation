#This class manages beachbody calm.io servers
class bb_calm{

  # Packages are installed for calm.io
  package {
    'redhat-lsb':
        ensure    => installed;
    'bzip2':
        ensure    => installed,
  }

  #Stop & disable services (Calm.io Requirement)
  service {
    'postfix':
        ensure    => stopped,
        enable    => false;
    'python-calm':
        ensure    => running,
        enable    => true
        #Need subscribe here
  }

  file { '/root/Calm-1.8.1.run':
        ensure    => file,
        mode      => '0755',
        source    => 'puppet://yum.beachbody.local/yum/misc/Calm-1.8.1.run'
        #may need to change path/name
  }

  exec {'unpack installer':
        command   => '/bin/sh /root/Calm-1.8.1.run',
        user      => root,
        creates   => '/opt/calmio/installer_scripts/setup.sh',
        require   => [ package['bzip2'], file ['/root/Calm-1.8.1.run'] ],
        notify    => exec['run installer'],
  }

  exec {'run installer':
        command   => '/bin/sh /opt/calmio/installer_scripts/setup.sh',
        user      => root,
        #find out what this creates
  }

}
