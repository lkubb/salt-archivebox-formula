# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as archivebox with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

ArchiveBox environment files are managed:
  file.managed:
    - names:
      - {{ archivebox.lookup.paths.config_archivebox }}:
        - source: {{ files_switch(
                        ["archivebox.env", "archivebox.env.j2"],
                        config=archivebox,
                        lookup="archivebox environment file is managed",
                        indent_width=10,
                     )
                  }}
      - {{ archivebox.lookup.paths.config_sonic }}:
        - source: {{ files_switch(
                        ["sonic.env", "sonic.env.j2"],
                        config=archivebox,
                        lookup="sonic environment file is managed",
                        indent_width=10,
                     )
                  }}
      - {{ archivebox.lookup.paths.config_pihole }}:
        - source: {{ files_switch(
                        ["pihole.env", "pihole.env.j2"],
                        config=archivebox,
                        lookup="pihole environment file is managed",
                        indent_width=10,
                     )
                  }}
      - {{ archivebox.lookup.paths.config_pywb }}:
        - source: {{ files_switch(
                        ["pywb.env", "pywb.env.j2"],
                        config=archivebox,
                        lookup="pywb environment file is managed",
                        indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ archivebox.lookup.user.name }}
    - makedirs: true
    - template: jinja
    - require:
      - user: {{ archivebox.lookup.user.name }}
    - require_in:
      - ArchiveBox is installed
    - context:
        archivebox: {{ archivebox | json }}

{%- if archivebox.sonic.enable %}

Sonic config file is managed:
  file.managed:
    - name: {{ archivebox.lookup.paths.sonic_cfg }}
    - source: {{ files_switch(
                    ["sonic.cfg", "sonic.cfg.j2"],
                    config=archivebox,
                    lookup="Sonic config file is managed",
                 )
              }}
    - mode: '0644'
    - user: {{ archivebox.lookup.user.name }}
    - group: {{ archivebox.lookup.user.name }}
    - makedirs: true
    - template: jinja
    - require:
      - user: {{ archivebox.lookup.user.name }}
    - watch_in:
      - ArchiveBox is installed
    - context:
        archivebox: {{ archivebox | json }}
{%- endif %}
