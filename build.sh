#!/bin/bash

TRUE=0
FALSE=1

function lib::logging::format() {
    # shellcheck disable=SC2059,SC2086,SC2048
    printf "$1" ${*:2}
}

function lib::logging::is_color_supported() {
    if echo "${TERM}" | grep -q "color"; then
        return ${TRUE}
    else
        return ${FALSE}
    fi
}

function lib::logging::info() {
    if lib::logging::is_color_supported; then
        printf "\x1b[38;5;111m[INFO]\x1b[0m %s\n" "$(lib::logging::format "$*")"
    else
        printf "[INFO] %s\n" "$(lib::logging::format "$*")"
    fi
}

function lib::logging::success() {
    if lib::logging::is_color_supported; then
        printf "\x1b[38;5;112m%s\x1b[0m\n" "$(lib::logging::format "$*")"
    else
        printf "%s\n" "$(lib::logging::format "$*")"
    fi
}

lib::logging::info "Restoring Nuget packages..."
dotnet restore

lib::logging::info "Building language server..."
dotnet publish src/LanguageServer/LanguageServer.csproj -o "$PWD"/out/language-server

lib::logging::success "Done building project"
