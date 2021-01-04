#!/usr/bin/env bash

find src/ | entr -cps 'elm make --output=app.js --debug src/Main.elm'
