# Install RUST

https://rust-lang.org/tools/install/

## Install `just`
[just](https://github.com/casey/just) is a handy way to save and run project-specific commands.

Install just with `cargo install just` or follow [os-specific installation](https://just.systems/man/zh/%E5%AE%89%E8%A3%85%E5%8C%85.html)

## Install shadowsocks

**client side**
```bash
git clone --depth=1 https://github.com/movonow/rsocks.git ~/rsocks
cd ~/rsocks
just build
just genkey
just upload {USER} {SERVER}

just install sslocal
```

**server side**
```bash
git clone --depth=1 https://github.com/movonow/rsocks.git ~/rsocks
cd ~/rsocks

just install ssserver
```