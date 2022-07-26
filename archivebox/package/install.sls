# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as archivebox with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

ArchiveBox user account is present:
  user.present:
{%- for param, val in archivebox.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ archivebox.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

ArchiveBox user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ archivebox.lookup.user.name }}
    - enable: {{ archivebox.install.rootless }}
    - require:
      - user: {{ archivebox.lookup.user.name }}

ArchiveBox paths are present:
  file.directory:
    - names:
      - {{ archivebox.lookup.paths.base }}
    - user: {{ archivebox.lookup.user.name }}
    - group: {{ archivebox.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ archivebox.lookup.user.name }}

ArchiveBox compose file is managed:
  file.managed:
    - name: {{ archivebox.lookup.paths.compose }}
    - source: {{ files_switch(['docker-compose.yml', 'docker-compose.yml.j2'],
                              lookup='ArchiveBox compose file is present'
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ archivebox.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        archivebox: {{ archivebox | json }}

ArchiveBox is installed:
  compose.installed:
    - name: {{ archivebox.lookup.paths.compose }}
{%- for param, val in archivebox.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in archivebox.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ archivebox.lookup.paths.compose }}
{%- if archivebox.install.rootless %}
    - user: {{ archivebox.lookup.user.name }}
    - require:
      - user: {{ archivebox.lookup.user.name }}
{%- endif %}
