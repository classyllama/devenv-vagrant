# CentOS 8 EOL

CentOS Linux 8 reached End Of Life (EOL) on December 31st, 2021 and all official repositories are not available after this date. It is still possible to use https://vault.centos.org repository which is a snapshot of the older trees that have been removed from the main CentOS servers.

As a temporary solution, we replace the official repositories automatically with Vault using `provisioning/centos8eol.yml` ansible script (starting 0.2.13 release of DevEnv), so it is possible to work with CentOS 8 environments.

For existing servers we recommend using the following command to update the repositories list:

    ./devenv centos8fix apply

More details:
https://www.centos.org/centos-linux-eol/
https://forums.centos.org/viewtopic.php?f=54&t=78708
https://wiki.centos.org/About/Product
