#!/bin/bash
macro() {
    echo &(pwd) > ~/pwd.save
}

polo() {
    cd $(cat ~/pwd.save)
}

clmacro() {
    rm -rf ~/pwd.save
}