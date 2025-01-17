# Nix

You can investigate nix tree with

```fish
nix path-info -rSh /run/current-system | sort -k2h
```

## Manual tests

You can build any configuration without leaving trash:

```fish
nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=/etc/nixos/hosts/hk47.nix --no-out-link
nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=/etc/nixos/hosts/skynet.nix --no-out-link
nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=/etc/nixos/hosts/kitt2000.nix --no-out-link
```

## Autotests

Yay! You can autotest all your linux configurations! You should because you can do it fo free, with simple setup.

Combine previous commands and a binary cache for CI.

### [Cachix](https://cachix.org/) Free 10GB binary cache for public repos

```fish
nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=/etc/nixos/hosts/hk47.nix --no-out-link | cachix push idempotent-desktop```

### [Example with Travis CI](https://github.com/ksevelyar/idempotent-desktop/blob/master/.travis.yml)

Travis is both free and slow, don't forget to populate Cachix for your tests:

## Links

- [nixcloud.io/tour](https://nixcloud.io/tour)
- [pills](https://nixos.org/nixos/nix-pills/why-you-should-give-it-a-try.html)
- [options](https://nixos.org/nixos/options.html)
- [manual](https://nixos.org/nixos/manual/')


## [.svg Tree](https://github.com/ksevelyar/idempotent-desktop/blob/master/nix-store.svg)

![nix-store](https://github.com/ksevelyar/idempotent-desktop/blob/master/nix-store.svg)
