# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as archivebox with context %}

include:
  - {{ sls_service_clean }}

# This does not lead to the containers/services being rebuilt
# and thus differs from the usual behavior
ArchiveBox environment files are absent:
  file.absent:
    - names:
      - {{ archivebox.lookup.paths.config_archivebox }}
      - {{ archivebox.lookup.paths.config_sonic }}
      - {{ archivebox.lookup.paths.config_pihole }}
      - {{ archivebox.lookup.paths.config_pywb }}
{%- if archivebox.sonic.enable %}
      - {{ archivebox.lookup.paths.sonic_cfg }}
{%- endif %}
      - {{ archivebox.lookup.paths.base | path_join(".saltcache.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
