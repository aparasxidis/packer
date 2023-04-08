#!/usr/bin/env sh
#
# CIS-LBK Recommendation Function
# ~/CIS-LBK/functions/recommendations/nix_fed28_ensure_authselect_includes_with_faillock.sh
# 
# Name                Date       Description
# ------------------------------------------------------------------------------------------------
# Eric Pinnell       09/24/20    Recommendation "Ensure authselect includes with-faillock"
# 
fed28_ensure_authselect_includes_with_faillock()
{
	echo "- $(date +%d-%b-%Y' '%T) - Starting $RNA" | tee -a "$LOG" 2>> "$ELOG"
	test=""
	if authselect current | grep -q with-faillock; then
		test=passed
	else
		custprofile="$(authselect list | awk -F / '/custom\// { print $2 }' | cut -f1)"
		if [ -z "$custprofile" ] || [ "$(echo "$custprofile" | awk '{total=total+NF};END{print total}')" != 1 ]; then
			test=manual
		else
			authselect select custom/"$custprofile" with-sudo with-faillock without-nullok --force
			authselect current | grep -q with-faillock && test=remediated
		fi
	fi	
	# Set return code and return
	case "$test" in
		passed)
			echo "Recommendation \"$RNA\" No remediation required" | tee -a "$LOG" 2>> "$ELOG"
			return "${XCCDF_RESULT_PASS:-101}"
			;;
		remediated)
			echo "Recommendation \"$RNA\" successfully remediated" | tee -a "$LOG" 2>> "$ELOG"
			return "${XCCDF_RESULT_PASS:-103}"
			;;
		manual)
			echo "Recommendation \"$RNA\" requires manual remediation" | tee -a "$LOG" 2>> "$ELOG"
			return "${XCCDF_RESULT_FAIL:-106}"
			;;
		*)
			echo "Recommendation \"$RNA\" remediation failed" | tee -a "$LOG" 2>> "$ELOG"
			return "${XCCDF_RESULT_FAIL:-102}"
			;;
	esac
}