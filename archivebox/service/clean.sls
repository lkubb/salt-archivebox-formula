# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as archivebox with context %}

archivebox service is dead:
  compose.dead:
    - name: {{ archivebox.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if archivebox.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ archivebox.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if archivebox.install.rootless %}
    - user: {{ archivebox.lookup.user.name }}
{%- endif %}

archivebox service is disabled:
  compose.disabled:
    - name: {{ archivebox.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if archivebox.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ archivebox.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if archivebox.install.rootless %}
    - user: {{ archivebox.lookup.user.name }}
{%- endif %}
