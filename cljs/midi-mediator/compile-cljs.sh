#!/usr/bin/env bash

find src/ | entr -cps 'cljs-compile code'
