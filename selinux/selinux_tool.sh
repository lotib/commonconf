#!/bin/bash

packages=( selinux-basics selinux-policy-default auditd )


function status()
{
    sestatus

    getenforce
    setenforce 1

    semanage login -l

    # su -lc 'touch /.autorelabel'

    sesearch --allow -s httpd_t -c file -p write
}
