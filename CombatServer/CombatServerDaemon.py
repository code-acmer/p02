#!/usr/bin/env python

import daemon
import sys
import time
import logging
import logging.config
from daemon import DaemonContext

DEBUG = 1

logging.config.fileConfig('./config/log_config.conf')

if DEBUG:
    logger = logging.getLogger('publish')
else:
    logger = logging.getLogger('publish')

PID_STYLE = '/tmp/combat_server_daemon_%s.pid'


def do_log(PidFile):
    while True:
        logger.info('%s log.' % PidFile)
        time.sleep(5)

        
class CombatServerDaemonManger(object):

    def __init__(self, WorkerNumber):
        """init for manager"""
        self.worker_number = WorkerNumber
        self.daemons = []
        for index in range(WorkerNumber):
            self.daemons.append(DaemonContext(pidfile = PID_STYLE % index))

    def start(self):
        """start all daemons"""
        logger.debug('start all combat server daemon: range %s' % self.worker_number)
        for _daemon in self.daemons:
            with _daemon:
                do_log(_daemon.pidfile)
        logger.debug('all started.')

    def stop(self):
        """stop all daemons"""
        logger.debug('stop all combat server daemon: range %s' % self.worker_number)
        for _daemon in self.daemons:
            _daemon.close()
        logger.debug('all stopped.')

    def restart(self):
        """restart all daemons
        """
        logger.debug('restart all combat server daemon: range %s' % self.worker_number)
        self.stop()
        self.start()
        logger.debug('all restarted.')

daemonManager = CombatServerDaemonManger(10)
            
if __name__ == "__main__":

    if len(sys.argv) == 2:
        if 'start' == sys.argv[1]:
            daemonManager.start()
        elif 'stop' == sys.argv[1]:
            daemonManager.stop()
        elif 'restart' == sys.argv[1]:
            daemonManager.restart()
        else:
            logger.debug("Unknown command for input.")
            sys.exit(2)
        sys.exit(0)
    else:
        logger.debug("usage: %s start | stop | restart" % sys.argv[0])
        sys.exit(2)
            

