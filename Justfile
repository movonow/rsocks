build:
    cargo build --release --features "full"

install: build
    sudo make install TARGET=release

upload: build
    scp target/release/sslocal \
        target/release/ssserver \
        target/release/ssurl \
        target/release/ssmanager \
        target/release/ssservice \
        movon@$ALIYUN_HOST:~/rsocks/target/release/

genkey:
    ssservice genkey -m "2022-blake3-aes-256-gcm"