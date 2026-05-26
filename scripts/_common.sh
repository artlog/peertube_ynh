	#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# Obtain the (empty string), __2, __3, cf the DB suffix in production.yaml...
db_suffix="$(echo $app | sed 's/peertube//g')"

build_vips() {
    # as root
    apt install build-essential pkg-config libglib2.0-dev libexpat1-dev meson
    pushd /home/yunohost.app/peertube/
    vips_pkg_name=vips-${vips_version}
    # don't download it twice
    if [[ ! -d ${vips_pkg_name} ]]
    then
	ynh_hide_warnings ynh_exec_as_app wget https://github.com/libvips/libvips/releases/download/v${vips_version}/${vips_pkg_name}.tar.xz
	ynh_hide_warnings ynh_exec_as_app tar -xf ${vips_pkg_name}.tar.xz
    fi
    pushd  ${vips_pkg_name}
    ynh_hide_warnings ynh_exec_as_app meson setup build
    pushd build
    ynh_hide_warnings ynh_exec_as_app meson compile
    # FIXME it fails in tests ... should fix, missing libraries ?
    #ynh_hide_warnings ynh_exec_as_app meson test
    # as root
    ynh_hide_warnings meson install
    popd # build
    popd # vips
    popd # peertube
}
