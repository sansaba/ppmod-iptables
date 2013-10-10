class iptables {
  case $hostname {
    'machine1': { $iptablesfile = $hostname }
    'machine2': { $iptablesfile = $hostname }
    default: { $iptablesfile = 'default' }
  }
  case $hostname {
    /^web*/: { $httpport = true }
    /^webappname*/: { $httpport = true }
    /^webappname2*/: { $httpport = true }
    default: { $httpport = false }
  }
  case $hostname {
    /^mysqlserver/: { $dbport = true }
    default: { $dbport = false }
  }
  
  file {
    "rules":
      ensure => present,
      path => "/etc/sysconfig/iptables",
      content => template("iptables/${iptablesfile}.erb"),
      user => 'root',
      mode => 0600,
      notify => Service['iptables'];
  }
  service {
    "iptables":
      ensure => running,
      enable => true,
      hasstatus => true,
      hasrestart => true;
  }
}