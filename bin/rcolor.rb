#!/usr/bin/env ruby

str="________"
(30..37).each {|i| printf "    \e[0;%dm%02d\e[0m    ", i, i-30}
puts
(30..37).each {|i| printf "    \e[1;%dm%02d\e[0m    ", i, i-22}
puts
(40..47).each {|i| printf " \e[%dm\e[%dm%s\e[0m ", i, i-10, str}
puts
(100..107).each {|i| printf " \e[%dm\e[1;%dm%s\e[0m ", i, i-70, str}
puts
