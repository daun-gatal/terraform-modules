<configuration>
%{ for name, value in config ~}
  <property>
    <name>${name}</name>
    <value>${value}</value>
  </property>
%{ endfor ~}
</configuration>
