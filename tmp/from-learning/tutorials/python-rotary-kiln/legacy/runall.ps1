# $env:RUST_BACKTRACE='full'
# $env:RUST_BACKTRACE=1
$env:RUST_BACKTRACE=0

# Binaries
cargo run --bin rotary_kiln

# Examples
cargo run --example check_stepwise_combustion
cargo run --example check_thermo_data_gas
cargo run --example check_thermo_model_gas