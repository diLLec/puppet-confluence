define confluence::conf (
  $value,
  $key = $name,
  $config_file = "${confluence::homedir}/confluence.cfg.xml",
) {
  require Class[confluence::install]
  
  $aug_changes = [
    sprintf('defnode entry /files%s/confluence-configuration/properties/property[#attribute/name = "%s"]'
      $config_file, $key),
    sprintf('set $entry/#text "%s"'
      $config_file, $value),
    sprintf('set $entry/#attribute/name "%s"'
      $config_file, $key),     
  ]

  augeas { "${config_file} - ${key}":
    lens    => 'Xml.lns',
    incl    => $config_file,
    onlyif  => "get /files${config_file}/confluence-configuration/setupStep/#text == complete",
    changes => [
      $aug_path,
    ],
  }

  if $confluence::manage_service {
    Augeas<| |> ~> Service['confluence']
  }
}
