#!/usr/bin/env bash

# https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#2-basic-settings
# https://github.com/akinomyoga/ble.sh/blob/master/blerc.template

bleopt prompt_ps1_transient=always

## "exec_elapsed_mark" specifies the format of the command execution time
## report.  It takes two arguments: the first is the string that explains the
## elapsed time, and the second is a number that represents the percentage of
## CPU core usage.  "exec_elapsed_enabled" specifies the condition that the
## command execution time report is displayed after the command execution.  The
## condition is expressed by an arithmetic expression, where a non-zero result
## causes displaying the report.  In the arithmetic expression, variables
## "real", "{usr,sys}{,_self,_child}", and "cpu" can be used.  "real"
## represents the elapsed time.  "usr" and "sys" represent the user and system
## time, respectively.  The suffixes "_self" and "_child" represent the part
## consumed in the main shell process and the other child processes including
## subshells and external programs, respectively.  "cpu" represents the
## percentage of the CPU core usage in integer, which can be calculated by
## "(usr+sys)*100/real".  The other values are all in unit of milliseconds.

bleopt exec_elapsed_mark=
#bleopt exec_elapsed_enabled='usr+sys>=10000'

#bleopt complete_auto_complete=1
#bleopt complete_menu_complete=1
#bleopt complete_menu_filter=1

bleopt complete_menu_color_match=on
bleopt exec_errexit_mark=

# Syntax Highlighting
ble-face -s argument_error 'fg=#ffc7c7'
ble-face -s argument_option 'fg=#f3b175'
ble-face -s auto_complete 'fg=#5c617d'
ble-face -s cmdinfo_cd_cdpath 'fg=#80d7fe,bg=#5c617d,italic'
ble-face -s command_alias 'fg=#ceffc9'
ble-face -s command_builtin 'fg=#ceffc9'
ble-face -s command_directory 'fg=#c4effa'
ble-face -s command_file 'fg=#ceffc9'
ble-face -s command_function 'fg=#ceffc9'
ble-face -s command_keyword 'fg=#eccef0'
ble-face -s disabled 'fg=#5c617d'
ble-face -s filename_directory 'fg=#c4effa'
ble-face -s filename_directory_sticky 'fg=#5c617d,bg=#d2fd9d'
ble-face -s filename_executable 'fg=#d2fd9d,bold'
ble-face -s filename_ls_colors 'none'
ble-face -s filename_orphan 'fg=#47e7b1,bold'
ble-face -s filename_other 'none'
ble-face -s filename_setgid 'fg=#5c617d,bg=#f3b175,underline'
ble-face -s filename_setuid 'fg=#5c617d,bg=#f3b175,underline'
ble-face -s menu_filter_input 'fg=#5c617d,bg=#f3b175'
ble-face -s overwrite_mode 'fg=#5c617d,bg=#47e7b1'
ble-face -s prompt_status_line 'bg=#5c617d'
ble-face -s region 'bg=#5c617d'
ble-face -s region_insert 'bg=#5c617d'
ble-face -s region_match 'fg=#5c617d,bg=#f3b175'
ble-face -s region_target 'fg=#5c617d,bg=#c9ccfb'
ble-face -s syntax_brace 'fg=#5c617d'
ble-face -s syntax_command 'fg=#80d7fe'
ble-face -s syntax_comment 'fg=#f3b175'
ble-face -s syntax_delimiter 'fg=#5c617d'
ble-face -s syntax_document 'fg=#f4f3f2,bold'
ble-face -s syntax_document_begin 'fg=#f4f3f2,bold'
ble-face -s syntax_error 'fg=#ffc7c7'
ble-face -s syntax_escape 'fg=#f096b7'
ble-face -s syntax_expr 'fg=#c9ccfb'
ble-face -s syntax_function_name 'fg=#c9ccfb'
ble-face -s syntax_glob 'fg=#f3b175'
ble-face -s syntax_history_expansion 'fg=#c9ccfb,italic'
ble-face -s syntax_param_expansion 'fg=#cccccc,bold'
ble-face -s syntax_quotation 'fg=#fdf7cd'
ble-face -s syntax_tilde 'fg=#c9ccfb'
ble-face -s syntax_varname 'fg=#f4f3f2'
ble-face -s varname_array 'fg=#cccccc,bold'
ble-face -s varname_empty 'fg=#cccccc,bold'
ble-face -s varname_export 'fg=#cccccc,bold'
ble-face -s varname_expr 'fg=#cccccc,bold'
ble-face -s varname_hash 'fg=#cccccc,bold'
ble-face -s varname_number 'fg=#cccccc,bold'
ble-face -s varname_readonly 'fg=#cccccc,bold'
ble-face -s varname_transform 'fg=#cccccc,bold'
ble-face -s varname_unset 'bg=#ffc7c7,fg=#5c617d'
ble-face -s vbell_erase 'bg=#5c617d'
