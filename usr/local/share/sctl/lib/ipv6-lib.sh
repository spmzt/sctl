#!/bin/sh

ipv6_rand()
{
    openssl rand -hex 8 | sed "s/.\{4\}/&:/g; s/:\$//"
}