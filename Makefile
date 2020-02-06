rustup.sh:
	curl https://sh.rustup.rs -sSf > rustup.sh

~/.cargo/bin/cargo: rustup.sh
	sh rustup.sh -y --default-toolchain=nightly

iperf/src/iperf: iperf/src/*.c
	cd iperf && ./autogen.sh && ./configure
	make -C iperf

udping/target/debug/udping_server udping/target/debug/udping_client: ~/.cargo/bin/cargo $(shell find udping/src -name "*.rs")
	cd udping && ~/.cargo/bin/cargo build

nimbus/target/debug/nimbus: ~/.cargo/bin/cargo nimbus/src/lib.rs
	cd nimbus && ~/.cargo/bin/cargo build

ccp_copa/target/debug/copa: ~/.cargo/bin/cargo $(shell find ccp_copa/src -name "*.rs")
	cd ccp_copa && ~/.cargo/bin/cargo build

# kernel cubic
# kernel bbr
# kernel vegas
