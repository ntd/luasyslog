#!/bin/sh
#
# Just a wrapper around autoreconf to generate the configuration
# scripts after a fresh repository clone/checkout.
#
# This script does *not* call configure (as usually done in other
# projects) because this would prevent VPATH builds.

autoreconf -is -Wall

printf "Now run configure to customize your building\n"
