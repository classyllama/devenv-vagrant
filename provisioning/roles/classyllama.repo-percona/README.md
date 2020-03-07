# Install via ansible-galaxy

  Add the repo to the ansible-galaxy install file

    ANSIBLE_GALAXY_CONTENTS=$(cat <<'CONTENTS_HEREDOC'
    - src: git@github.com:classyllama/ansible-role-repo-percona.git
      name: classyllama.repo-percona
      scm: git
    CONTENTS_HEREDOC
    )
    echo "${ANSIBLE_GALAXY_CONTENTS}" >> ansible_roles.yml

  Run the ansible-galaxy install to install roles from various repos

    ansible-galaxy -r ansible_roles.yml install

# Run role via playbook adhoc

  Create temporary playbook file
  
    TEMP_PLAYBOOK_FILE="TEMP_PLAY.yml"
    PLAYBOOK_CONTENTS=$(cat <<'CONTENTS_HEREDOC'
    ---
    - hosts: mage2-app
      become: true
      roles:
        - classyllama.repo-percona
    CONTENTS_HEREDOC
    )
    echo "${PLAYBOOK_CONTENTS}" > ${TEMP_PLAYBOOK_FILE}
    ansible-playbook -i inventory-* ${TEMP_PLAYBOOK_FILE} --diff --check

  After verifying the changes, run the play and remove the temp playbook file
  
    ansible-playbook -i inventory-* ${TEMP_PLAYBOOK_FILE} --diff
    rm ${TEMP_PLAYBOOK_FILE}
