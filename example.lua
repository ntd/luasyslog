-- This script works only with luasyslog properly installed
local syslog = require 'logging.syslog'

-- Generate some log with the default facility
local logger = syslog('luasyslog1')
logger:debug('Debug message')
logger:info('Info message')

-- Generate some log with a specific facility
local lsyslog = require 'lsyslog'
logger = syslog('luasyslog2', lsyslog.FACILITY.CRON)
logger:warn('Warning message')
logger:error('Error message')
