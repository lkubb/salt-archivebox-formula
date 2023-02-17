# vim: ft=sls

{#-
    Starts the archivebox, sonic, pihole, pywb container services
    and enables them at boot time.
    Has a dependency on `archivebox.config`_.
#}

include:
  - .running
