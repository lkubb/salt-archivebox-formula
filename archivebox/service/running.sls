# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as archivebox with context %}

include:
  - {{ sls_config_file }}

ArchiveBox service is enabled:
  compose.enabled:
    - name: {{ archivebox.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if archivebox.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ archivebox.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - ArchiveBox is installed
{%- if archivebox.install.rootless %}
    - user: {{ archivebox.lookup.user.name }}
{%- endif %}

ArchiveBox service is running:
  compose.running:
    - name: {{ archivebox.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if archivebox.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ archivebox.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if archivebox.install.rootless %}
    - user: {{ archivebox.lookup.user.name }}
{%- endif %}
    - watch:
      - ArchiveBox is installed
