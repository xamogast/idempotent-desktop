(window.webpackJsonp=window.webpackJsonp||[]).push([[15],{365:function(t,s,n){"use strict";n.r(s);var i=n(43),e=Object(i.a)({},(function(){var t=this,s=t.$createElement,n=t._self._c||s;return n("ContentSlotsDistributor",{attrs:{"slot-key":t.$parent.slotKey}},[n("h1",{attrs:{id:"nix"}},[n("a",{staticClass:"header-anchor",attrs:{href:"#nix"}},[t._v("#")]),t._v(" Nix")]),t._v(" "),n("p",[t._v("You can investigate nix tree with")]),t._v(" "),n("div",{staticClass:"language-fish extra-class"},[n("pre",{pre:!0,attrs:{class:"language-text"}},[n("code",[t._v("nix path-info -rSh /run/current-system | sort -k2h\n")])])]),n("h2",{attrs:{id:"manual-tests"}},[n("a",{staticClass:"header-anchor",attrs:{href:"#manual-tests"}},[t._v("#")]),t._v(" Manual tests")]),t._v(" "),n("p",[t._v("You can build any configuration without leaving trash:")]),t._v(" "),n("div",{staticClass:"language-fish extra-class"},[n("pre",{pre:!0,attrs:{class:"language-text"}},[n("code",[t._v("nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=/etc/nixos/hosts/hk47.nix --no-out-link\nnix-build '<nixpkgs/nixos>' -A vm -I nixos-config=/etc/nixos/hosts/skynet.nix --no-out-link\nnix-build '<nixpkgs/nixos>' -A vm -I nixos-config=/etc/nixos/hosts/kitt2000.nix --no-out-link\n")])])]),n("h2",{attrs:{id:"autotests"}},[n("a",{staticClass:"header-anchor",attrs:{href:"#autotests"}},[t._v("#")]),t._v(" Autotests")]),t._v(" "),n("p",[t._v("Yay! You can autotest all your linux configurations! You should because you can do it fo free, with simple setup.")]),t._v(" "),n("p",[t._v("Combine previous commands and a binary cache for CI.")]),t._v(" "),n("h3",{attrs:{id:"cachix-free-10gb-binary-cache-for-public-repos"}},[n("a",{staticClass:"header-anchor",attrs:{href:"#cachix-free-10gb-binary-cache-for-public-repos"}},[t._v("#")]),t._v(" "),n("a",{attrs:{href:"https://cachix.org/",target:"_blank",rel:"noopener noreferrer"}},[t._v("Cachix"),n("OutboundLink")],1),t._v(" Free 10GB binary cache for public repos")]),t._v(" "),n("div",{staticClass:"language-fish extra-class"},[n("pre",{pre:!0,attrs:{class:"language-text"}},[n("code",[t._v("nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=/etc/nixos/hosts/hk47.nix --no-out-link | cachix push idempotent-desktop```\n\n### [Example with Travis CI](https://github.com/ksevelyar/idempotent-desktop/blob/master/.travis.yml)\n\nTravis is both free and slow, don't forget to populate Cachix for your tests:\n\n## Links\n\n- [nixcloud.io/tour](https://nixcloud.io/tour)\n- [pills](https://nixos.org/nixos/nix-pills/why-you-should-give-it-a-try.html)\n- [options](https://nixos.org/nixos/options.html)\n- [manual](https://nixos.org/nixos/manual/')\n\n\n## [.svg Tree](https://github.com/ksevelyar/idempotent-desktop/blob/master/nix-store.svg)\n\n![nix-store](https://github.com/ksevelyar/idempotent-desktop/blob/master/nix-store.svg)\n")])])])])}),[],!1,null,null,null);s.default=e.exports}}]);