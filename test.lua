-- Get the current/working directory and put it in pwd
local f = io.popen('pwd')
local pwd = tostring(f:read('*a')):gsub('[\r\n]', '')
f:close()

-- Prepend pwd on Lua and C path, so the uninstalled C and Lua modules
-- are picked up first
package.path = pwd .. '/?.lua;' .. package.path
package.cpath = pwd .. '/?.so;' .. package.cpath


-- Shoud be "require 'logging.syslog' when installed
local syslog = require 'syslog'

-- Generate some log with the default facility
local logger = syslog('luasyslog1')
logger:debug('Debug message')
logger:info('Info message')

-- Generate some log with a specific facility
local lsyslog = require 'lsyslog'
logger = syslog('luasyslog2', lsyslog.FACILITY.CRON)
logger:warn('Warning message')
logger:error('Error message')
