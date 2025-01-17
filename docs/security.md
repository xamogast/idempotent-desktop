# Security

## GPG

### Create template for your keys

`nvim gpg.template`

```conf
Key-Type: eddsa
Key-Curve: Ed25519
Key-Usage: sign
Subkey-Type: ecdh
Subkey-Curve: Curve25519
Subkey-Usage: encrypt
Name-Real: dude
Name-Email: dude@domain.tld
Expire-Date: 0
%commit
```

### Generate a Ed25519 key

```fish
gpg --batch --generate-key gpg.template
```

### Enlist keys

```fish
gpg --list-secret-keys
```

You can use this key for pass now.

## [gopass](https://woile.github.io/gopass-presentation/)

Aliased to `p`.

### Init

`gopass init <gpg-id>`

### Generate password with special symbols and copy it to clipboard

`p generate -s mail/protonmail.com 80`

### Import your passwords to pass

[pass-import](https://github.com/roddhjav/pass-import#pass-import)

You can use `gopass` for fuzzy matchings (aliased to `p`) or GUI `qtpass` (binded to `Win+p`).

## [Tomb](https://www.dyne.org/software/tomb/)

[Quickstart](https://github.com/dyne/Tomb/wiki/Quickstart)

To create a 100MB tomb:

```sh
mkdir -p ~/.secrets && cd ~/.secrets

tomb dig -s 100 mrpoppybutthole.tomb
tomb forge mrpoppybutthole.tomb.key
tomb lock secret.tomb -k mrpoppybutthole.tomb.key
```

To open it, do `tomb open mrpoppybutthole.tomb -k mrpoppybutthole.tomb.key`

## [Mount .ssh and .password-store from tomb](https://github.com/dyne/Tomb/wiki/Advancedfeatures)

```fish
cd /run/media/ksevelyar/mrpoppybutthole
v bind-hooks
```

Change content to:

```
.ssh            .ssh
.password-store .password-store
.gnupg          .gnupg
```

and move this dirs to tomb.

Create empty folders:

```fish
mkdir -p ~/.password-store ~/.gnupg ~/ssh
```

Open tomb `tomb open mrpoppybutthole.tomb -k mrpoppybutthole.tomb.key`.

Done, now your ssh keys and passwords should be served from tomb.

[Also, with tomb you can bury your key inside jpeg](https://github.com/dyne/Tomb/wiki/Advancedfeatures#hide-the-key).

Run `tomb close` to unmount tomb.

## Opened ports

[firewall-desktop](https://github.com/ksevelyar/idempotent-desktop/blob/mast../services/net/firewall-desktop.nix)

## Show listening ports

`sudo lsof -Pni | grep -i listen`

## [sshd](https://github.com/ksevelyar/idempotent-desktop/blob/0c25763c040e5a50f393d2c2bb7c6eee616f37../services/common.nix#L9-L16)

Autostart disabled, use `sudo systemctl start sshd`

The port is 9922. Use `mosh --ssh="ssh -p 9922" user@host` or legacy `ssh user@host -p 9922` to connect.

In case your sshd is runninng you will see it in polybar with amount of active connects:

![polybar](https://i.imgur.com/zZz3AfZ.png)

The same for x11vnc.

### Check your ssh keys

```bash
bash -c 'for key in ~/.ssh/id_*; do ssh-keygen -l -f "${key}"; done | uniq'
```

> Today, the RSA is the most widely used public-key algorithm for SSH key. But compared to Ed25519, it’s slower and even considered not safe if it’s generated with the key smaller than 2048-bit length.

[upgrade-your-ssh-key-to-ed25519](https://medium.com/risan/upgrade-your-ssh-key-to-ed25519-c6e8d60d3c54)

`ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519`

## Fail2Ban

Currently integrated with `sshd`.

## hardened kernel

You can switch to the hardened kernel with one line: [sysctl.nix](https://github.com/ksevelyar/idempotent-desktop/blob/504570d52ab79463704e4ddcf908f82c593621../sys/sysctl.nix#L4-L6)

## Monitor

- [email](https://haveibeenpwned.com/)
