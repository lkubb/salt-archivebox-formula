Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``archivebox``
^^^^^^^^^^^^^^
*Meta-state*.

This installs the archivebox, sonic, pihole, pywb containers,
manages their configuration and starts their services.


``archivebox.package``
^^^^^^^^^^^^^^^^^^^^^^
Installs the archivebox, sonic, pihole, pywb containers only.
This includes creating systemd service units.


``archivebox.config``
^^^^^^^^^^^^^^^^^^^^^
Manages the configuration of the archivebox, sonic, pihole, pywb containers.
Has a dependency on `archivebox.package`_.


``archivebox.service``
^^^^^^^^^^^^^^^^^^^^^^
Starts the archivebox, sonic, pihole, pywb container services
and enables them at boot time.
Has a dependency on `archivebox.config`_.


``archivebox.clean``
^^^^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``archivebox`` meta-state
in reverse order, i.e. stops the archivebox, sonic, pihole, pywb services,
removes their configuration and then removes their containers.


``archivebox.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the archivebox, sonic, pihole, pywb containers
and the corresponding user account and service units.
Has a depency on `archivebox.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``archivebox.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the archivebox, sonic, pihole, pywb containers
and has a dependency on `archivebox.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``archivebox.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the archivebox, sonic, pihole, pywb container services
and disables them at boot time.


