#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

FLAGS="--std=93c -fsynopsys -fexplicit --ieee=synopsys --workdir=build"
mkdir -p build

run() {
    local top=$1; shift
    echo "=== $top ==="
    ghdl -a $FLAGS "$@"
    ghdl -e $FLAGS "$top"
    if ghdl -r $FLAGS "$top" --assert-level=error > "build/$top.log" 2>&1; then
        grep "report note" "build/$top.log" | sed 's/.*(report note): /  /'
    else
        echo "FAILED: $top"; cat "build/$top.log"; exit 1
    fi
}

run tb_regfile src/regfile.vhd tb/tb_regfile.vhd
run tb_alu_reg src/alu_if.vhd src/regfile.vhd src/ALU_REG.vhd tb/tb_alu_reg.vhd

echo "All testbenches passed."
