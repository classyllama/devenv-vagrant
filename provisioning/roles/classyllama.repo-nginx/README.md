# Ansible Nginx

* Installs nginx latest stable from official nginx repo
* Can install a specific AppStream version on EL8
* Supports RHEL/CentOS 6 / 7 / 8

## Example Usage

* Install from official nginx repo (default)

        use_classyllama_repo_nginx: true
        use_classyllama_repo_nginx_appstream: false

* Install from EL8 AppStream

        use_classyllama_repo_nginx: false
        use_classyllama_repo_nginx_appstream: true
        nginx_stream_version: "1.18"
