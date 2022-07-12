# Ansible Role: OpenSearch

Installs [OpenSearch](https://opensearch.org/) service on RHEL/CentOS. This role was built based on official code from https://github.com/opensearch-project/ansible-playbook.

OpenSearch is a community-driven, open source search and analytics suite derived from Apache 2.0 licensed Elasticsearch 7.10.2.

## Requirements

This role requires `openssl` installed on host for SSL certificates generation.

## Role Variables

An example of configuration:

    use_classyllama_opensearch: true
    os_admin_user: opensearch
    os_admin_password: strongpass

See `defaults/main.yml` for details.

## Dependencies

None.

## Example Playbook

    - hosts: all
      roles:
         - { role: classyllama.opensearch, tags: opensearch, when: use_classyllama_opensearch | default(false) }

## License

This work is licensed under the MIT license. See LICENSE file for details.