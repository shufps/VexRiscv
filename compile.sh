#!/bin/bash
[[ "$( basename "$0" )" == "compile_nodebug.sh" ]] && {
	sbt "runMain vexriscv.demo.ICCFPGA_NoDebug"
	true
} || {
	sbt "runMain vexriscv.demo.ICCFPGA"
}
