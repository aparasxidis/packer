#!/usr/bin/env sh
#
# CIS-LBK Cloud Team Built Recommendation Function
# ~/CIS-LBK/functions/fct/nix_fed_ensure_rsync_service_not_enabled_fct.sh
# 
# Name                Date       Description
# ------------------------------------------------------------------------------------------------
# Eric Pinnell       09/21/20    Recommendation "Ensure rsync service is not enabled"
#
fed_ensure_rsync_service_not_enabled_fct()
{
	# Ensure rsync service is not enabled
	echo
	echo \*\*\*\* Ensure\ rsync\ service\ is\ not\ enabled
	systemctl is-enabled rsync 2>>/dev/null && systemctl --now disable rsync

	return "${XCCDF_RESULT_PASS:-201}" 
}