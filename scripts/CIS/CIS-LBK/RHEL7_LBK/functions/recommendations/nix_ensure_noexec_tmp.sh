#!/usr/bin/env sh
#
# CIS-LBK Recommendation Function
# ~/CIS-LBK/functions/recommendations/nix_ensure_noexec_tmp.sh
# 
# Name                Date       Description
# ------------------------------------------------------------------------------------------------
# Eric Pinnell       09/10/20    Recommendation "Ensure noexec option set on /tmp partition"
# Eric Pinnell       00/09/20    Modified "Fixed bug in test"
# 
ensure_noexec_tmp()
{
	echo "- $(date +%d-%b-%Y' '%T) - Starting $RNA" | tee -a "$LOG" 2>> "$ELOG"
	test=""
	# Check to see if partition exists
	if mount | grep -Eq '\s\/tmp\s'; then
		# check to see if /tmp is configured in /etc/fstab
		if grep -E '^\s*[^#]+\s+\/tmp\s*' /etc/fstab; then
			if [ -z "$(grep -E '\s\/tmp\s' /etc/fstab | grep -v 'noexec')" ]; then
				test=passed
			else
				sed -ri '/s/^\s*([^#]+\s+\/tmp\s*\S+\s+)([^#]*)?(\s+[0-9]\s+[0-9])/\1\2,noexec\3' /etc/fstab
				[ -z "$(grep -E '\s\/tmp\s' /etc/fstab | grep -v 'noexec')" ] && test=remediated
				mount -o remount,noexec,nodev,nosuid /tmp
			fi
		elif [ -s /etc/systemd/system/local-fs.target.wants/tmp.mount ]; then
			if awk '/[Mount]/,0' /etc/systemd/system/local-fs.target.wants/tmp.mount | grep -Eq '^\s*Options=([^#]+,)?noexec'; then
				test=passed
			else
				sed -ri '/s/(^\s*Options=[^#]+)/\1,noexec'
				awk '/[Mount]/,0' /etc/systemd/system/local-fs.target.wants/tmp.mount | grep -Eq '^\s*Options=([^#]+,)?noexec' && test=remediated
				mount -o remount,noexec,nodev,nosuid /tmp
			fi
		fi
	else
		test=skipped
	fi
	echo "- $(date +%d-%b-%Y' '%T) - Completed $RNA" | tee -a "$LOG" 2>> "$ELOG"
	# Set return code and return
	if [ "$test" = passed ]; then
		echo "Recommendation \"$RNA\" No remediation required" | tee -a "$LOG" 2>> "$ELOG"
		return "${XCCDF_RESULT_PASS:-101}"
	elif [ "$test" = remediated ]; then
		echo "Recommendation \"$RNA\" successfully remediated" | tee -a "$LOG" 2>> "$ELOG"
		return "${XCCDF_RESULT_PASS:-103}"
	elif [ "$test" = skipped ]; then
		echo "Recommendation \"$RNA\" manual remediation required" | tee -a "$LOG" 2>> "$ELOG"
		return "${XCCDF_RESULT_FAIL:-106}"
	else
		echo "Recommendation \"$RNA\" remediation failed" | tee -a "$LOG" 2>> "$ELOG"
		return "${XCCDF_RESULT_FAIL:-102}"
	fi
}