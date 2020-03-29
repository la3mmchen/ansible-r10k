# ansible-r10k

Puppet has r10k. The ansible toolchain is lacking some convenient way to manage and deploy roles - in a defined version.

In case you search something to tackle this gap this repo might be helpful.

## howto

First put your inventory and config in `configs/` as well as the repos you want to pull. The execute the "ansible-r10k" run via:

```bash
    make release
```

