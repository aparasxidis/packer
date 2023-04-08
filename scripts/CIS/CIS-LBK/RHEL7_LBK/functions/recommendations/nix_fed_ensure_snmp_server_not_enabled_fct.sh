#!/usr/bin/env sh
#
# CIS-LBK Cloud Team Built Recommendation Function
# ~/CIS-LBK/functions/fct/nix_fed_ensure_snmp_server_not_enabled_fct.sh
# 
# Name                Date       Description
# ------------------------------------------------------------------------------------------------
# Eric Pinnell       09/21/20    Recommendation "Ensure SNMP Server is not enabled"
#
fed_ensure_snmp_server_not_enabled_fct()
{
	# Ensure SNMP Server is not enabled
	echo
	echo \*\*\*\* Ensure\ SNMP\ Server\ is\ not\ enabled
	systemctl is-enabled snmpd 2>>/dev/null | grep -q "enabled" && systemctl --now disable snmpd

	return "${XCCDF_RESULT_PASS:-201}"
}