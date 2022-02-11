# Mutagen

The DevEnv uses [Mutagen](https://mutagen.io/m) to sync files between the host and VM. There is a default Mutagen configuration file that has sane defaults for most config values, but certain settings must be configured on every project:

    sync:
      magento:
        alpha: "../../"
        beta: "www-data@example.lan:/var/www/data/magento/"
        mode: "two-way-resolved"
        symlink:
          mode: "ignore"
        ignore:
          vcs: true
          paths:
            - ".idea/*"
            - "var/"
            - "phpserver/"
            - "update/"
            - "pub/media/"
            - "pub/static/"
            - "tools/devenv/*"
            - "node_modules/"
        permissions:
          defaultFileMode: 664
          defaultDirectoryMode: 0775

We use `two-way-resolved` mechanism for bidirectional synchronization when the 'alpha' endpoint (host) automatically wins all conflicts, including cases where alpha’s deletions would overwrite beta’s modifications or creations. No conflicts can occur in this synchronization mode.

## Creating a New Project

To work on a new project, you need to edit the mutagen.yml file in the `<project>/tools/devenv`:

1. Edit the beta value and replace the example.lan hostname with the actual dev domain name (such as <project_short_name>.lan).
2. Review the ignore → paths array and confirm that these directories are safe to not be synced on this project. 
   Add any other directories which would add overhead to sync without providing development value.
3. Commit the mutagen.yml file into the repository.

## Usage

After spinning up and provisioning of a new VM (when `vagrant up` was finished successfully) it is neccessary to start file synchronization between the host and VM using:

    mutagen project start

from the `<project>/tools/devenv` folder.

Optionally, open a new terminal tab and run:

    mutagen sync monitor

to view the current status of file synchronization. Use `CTRL+C` to cancel the sync monitor.

Please note, `mutagen` should be launched before any operations that modify the files (for example before switching branches/pulling code) because if it was stopped it can cause files to get out of sync. However, it might be a good idea not to have `mutagen` running during the `composer install`:

    mutagen project terminate

and then start it after composer installation, i.e. the typicall workflow is to start the `mutagen` after building a new VM to synchronize the files into VM, wait for syncing to complete (using `mutagen sync monitor`), then terminate before running `composer install` and run it again.


When stopping to work on the project (before running `vagrant halt`) it is important to stop file synchronization using:

    mutagen project terminate

Please note, if you have `mutagen sync monitor` running, it will exit on its own one file synchronization stops.

## Upgrade

If `mutagen` was installed on macOS host via Brew to upgrade it to the latest version (0.13.1 currently) you can use the following command:

    brew upgrade mutagen

## Throubleshooting

In case when you noticed the synchronization isn't working it will be a good idea to check the status using `mutagen sync monitor` and to try to restart the synchronization process:

    mutagen project stop
    mutagen project start

If it doesn't help you may need to stop the synchronization and reload the daemon using the following commands:

    mutagen project stop
    mutagen daemon stop
    mutagen daemon start
    mutagen project start

When `mutagen` wasn't stopped before halting the VM it might require removing the lock file:

    $ mutagen project start
    Error: project already running
    $ rm mutagen.yml.lock
    $ mutagen project start
