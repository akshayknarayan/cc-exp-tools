all: iperf/src/iperf nimbus/target/debug/nimbus ccp_copa/target/debug/copa

rustup.sh:
	curl https://sh.rustup.rs -sSf > rustup.sh

~/.cargo/bin/cargo: rustup.sh
	sh rustup.sh -y --default-toolchain=nightly

iperf/src/iperf: iperf/src/*.c
	cd iperf && ./autogen.sh && ./configure
	make -C iperf

ccp-kernel/ccp.ko: ccp-kernel/tcp_ccp.c
	make -C ccp-kernel

nimbus/target/release/nimbus: ~/.cargo/bin/cargo nimbus/src/lib.rs
	cd nimbus && ~/.cargo/bin/cargo build --release

ccp_copa/target/release/copa: ~/.cargo/bin/cargo $(shell find ccp_copa/src -name "*.rs")
	cd ccp_copa && ~/.cargo/bin/cargo build --release

# kernel cubic
# kernel bbr
# kernel vegas
