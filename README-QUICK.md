# Install Rust

Install Rust from:

https://rust-lang.org/tools/install/

## Install `just`

[just](https://github.com/casey/just) is a simple task runner for project-specific commands.

Install it with `cargo install just` or follow the platform-specific instructions at:

https://just.systems/man/en/packages.html

## Install rsocks

Building rsocks requires a machine with at least 2 GB of RAM. Compile locally, then upload the binaries to the remote host.

Follow these steps in the order shown.

```bash
# On the local machine
git clone --depth=1 https://github.com/movonow/rsocks.git ~/rsocks
cd ~/rsocks
just build
just genkey
just install sslocal

# On the remote host
git clone --depth=1 https://github.com/movonow/rsocks.git ~/rsocks
cd ~/rsocks
mkdir -p target/release/

# Back on the local machine
just upload {USER} {SERVER}

# Finally, on the remote host
just install ssserver
```