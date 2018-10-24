### Testing for backup-env.yml Ansible Playbook

This directory provides a `docker-compose` environment for testing the `backup-env.yml` playbook.

To use this directory for testing, the following is required:

```bash
docker-compose run --rm backup_env
```

This will drop you into a `bash` shell inside the container within the `/ansible` directory. All the playbooks are mounted
as a volume so you can edit them within your favourite ide and changes should be instantly reflected within the container.

#### Check the database is running

Before you try running the `backup-env.yml` playbook, just check the database is running:

```bash
mysql -u root -h mysql --password="password" -e "select * from foo;" drupal_1
```

You should get this result:

```bash
[root@d0dd372a7fdc ansible]# mysql -u root -h mysql --password="password" -e "select * from foo;" drupal_1
+--------------------------------------------+
| hello_world                                |
+--------------------------------------------+
| this is a test of the communication system |
+--------------------------------------------+
[root@d0dd372a7fdc ansible]#
```

If you get that, you're good to run the `backup-env.yml` playbook using the following:

```bash
ansible-playbook backup-env.yml
```

Backups will be stored into `/drupal-backups` on the container filesystem

### Clean-up

When you're finished, simply use `docker-compose down -v` to tidy up your environment.