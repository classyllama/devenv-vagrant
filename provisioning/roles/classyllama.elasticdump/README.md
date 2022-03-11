# Ansible Role: ElasticDump utility

Installs 'elasticdump' utility for dumping/restoring ElasticSearch indices. It requires nodejs installed on the server.

## Requirements

    use_classyllama_repo_nodesource: true
    nodejs_update: true
    install_nodejs: true

## Role Variables

    use_classyllama_elasticdump: true|false

## Dependencies

     - { role: classyllama.repo-nodesource, tags: nodejs, when: use_classyllama_repo_nodesource | default(false) }

## Example Playbook

    - hosts: all
      roles:
         - { role: classyllama.elasticdump, tags: elasticdump, when: use_classyllama_elasticdump | default(false) }

## Usage example

    # Copy an index from production to staging with mappings:
    elasticdump \
      --input=http://production.es.com:9200/my_index \
      --output=http://staging.es.com:9200/my_index \
      --type=mapping
    elasticdump \
      --input=http://production.es.com:9200/my_index \
      --output=http://staging.es.com:9200/my_index \
      --type=data
    
     # Backup index data to a file:
    elasticdump \
      --input=http://production.es.com:9200/my_index \
      --output=/data/my_index_mapping.json \
      --type=mapping
    elasticdump \
      --input=http://production.es.com:9200/my_index \
      --output=/data/my_index.json \
      --type=data

     # Backup and index to a gzip using stdout:
    elasticdump \
      --input=http://production.es.com:9200/my_index \
      --output=$ \
      | gzip > /data/my_index.json.gz
    
    # Backup the results of a query to a file
    elasticdump \
      --input=http://production.es.com:9200/my_index \
      --output=query.json \
      --searchBody "{\"query\":{\"term\":{\"username\": \"admin\"}}}"

## Notes

Please visit https://github.com/elasticsearch-dump/elasticsearch-dump for usage information

## License

This work is licensed under the MIT license. See LICENSE file for details.
