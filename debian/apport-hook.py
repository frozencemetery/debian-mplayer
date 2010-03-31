#!/usr/bin/python

'''apport package hook for mplayer

(c) 2009 Author: Reinhard Tartler <siretart@tauware.de>
'''

from apport.hookutils import *
from os import path

def add_info(report):
    # Build System Environment
    report['system'] = "distro = Ubuntu, architecture = %s, kernel = %s" % (command_output(['uname','-m']), command_output(['uname','-r']))

    attach_related_packages(report, [
            "libavcodec52",
            "libavcodec-extra-52",
            ])
            
    attach_file_if_exists(report, path.expanduser('~/.mplayer/config'), 'UserConf')
    attach_file(report, '/etc/mplayer/mplayer.conf', 'SystemConf')
    attach_alsa(report)

## DEBUGING ##
if __name__ == '__main__':
    report = {}
    add_info(report)
    for key in report:
        print '[%s]\n%s' % (key, report[key])
