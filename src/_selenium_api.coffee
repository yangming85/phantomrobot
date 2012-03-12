###
Copyright (C) 2011-2012  Asko Soukka <asko.soukka@iki.fi>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
###

###
Dummy keywords to please Selenium-tests
###


"Start Selenium server": (params, respond) ->
    respond status: "PASS"


"Stop Selenium server": (params, respond) ->
    rspond status: "PASS"


"Set Selenium timeout": (params, respond) ->
    @["Set Phantom timeout"] params, respond


"Set Selenium speed": (params, respond) ->
    speed = params[1][0]
    respond status: "PASS", return: speed
