#!/usr/bin/env bash

rm -rf python_build

python3 nitriding.py

cd python_build/ceqsier/tcp_iface_ceqsier && RUST_LOG=tcp_iface=info cargo run

