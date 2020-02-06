all: iperf/src/iperf nimbus/target/release/nimbus ccp_copa/target/release/copa

rustup.sh:
	curl https://sh.rustup.rs -sSf > rustup.sh

~/.cargo/bin/cargo: rustup.sh
	sh rustup.sh -y --default-toolchain=nightly

go1.13.7.linux-amd64.tar.gz: 
	wget https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz

~/go/bin/go: go1.13.7.linux-amd64.tar.gz
	tar -C ~/go -xzf go1.13.7.linux-amd64.tar.gz

cc-monitor/cc-server cc-monitor/ccperf: $(shell find ccp_copa/src -name "*.go")
	env GOROOT=~/go PATH=$(shell $PATH):$GOROOT/bin make -C cc-monitor

ccp-kernel/ccp.ko: ccp-kernel/tcp_ccp.c
	make -C ccp-kernel

nimbus/target/release/nimbus: ~/.cargo/bin/cargo nimbus/src/lib.rs
	cd nimbus && ~/.cargo/bin/cargo build --release

ccp_copa/target/release/copa: ~/.cargo/bin/cargo $(shell find ccp_copa/src -name "*.rs")
	cd ccp_copa && ~/.cargo/bin/cargo build --release

# kernel cubic
# kernel bbr
# kernel vegas
