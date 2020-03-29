# ansible-r10k

Puppet has r10k. The ansible toolchain is lacking some convenient way to manage and deploy roles - in a defined version.

In case you search something to tackle this gap this repo might be helpful.

## howto

First put your inventory and config in `configs/` as well as the repos you want to pull. The execute the "ansible-r10k" run via:

Fetch your configured dependencies. This should provide you with a valid ansible setup:

```bash
    make dependencies
    ************ loading dependencies


    PLAY [localhost] ***************************************************************************************************************************************************************************************************************************************************************

    TASK [set_fact] ****************************************************************************************************************************************************************************************************************************************************************
    ok: [localhost -> localhost]

    TASK [manage local directories] ************************************************************************************************************************************************************************************************************************************************
    changed: [localhost -> localhost] => (item={'path': 'inventories', 'state': 'absent'})
    changed: [localhost -> localhost] => (item={'path': 'roles', 'state': 'absent'})
    changed: [localhost -> localhost] => (item={'path': 'runtime', 'state': 'absent'})
    changed: [localhost -> localhost] => (item={'path': 'runtime', 'state': 'directory'})
    changed: [localhost -> localhost] => (item={'path': 'roles', 'state': 'directory'})
    changed: [localhost -> localhost] => (item={'path': 'inventories', 'state': 'directory'})
    ok: [localhost -> localhost] => (item={'path': 'artefacts', 'state': 'directory'})
    (...)
```

Run it:

```bash
    make release
```