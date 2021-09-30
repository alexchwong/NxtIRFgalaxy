#!/bin/bash

TESTDIR=tests
TMPDIR=test_tmp
BINDIR=nxtirf
PWD=`pwd`

IRFREF=${TESTDIR}/IRFinder.ref.gz

SAMPLEBAM=${TESTDIR}/02H003.bam
SAMPLEIRF=${TESTDIR}/02H003.txt.gz
SAMPLECOV=${TESTDIR}/02H003.cov

TESTIRF=${TMPDIR}/test.txt.gz
TESTCOV=${TMPDIR}/test.cov

run_tests () {
	# Test nxtirf about
	${BINDIR}/nxtirf about
	
	# Test nxtirf main
	${BINDIR}/nxtirf main ${SAMPLEBAM} ${IRFREF} ${TESTIRF} ${TESTCOV}
   
	MD5IRF=`zcat ${SAMPLEIRF} | md5sum | cut -d\t  -f1`
	MD5TESTIRF=`zcat ${TESTIRF} | md5sum | cut -d\t  -f1`
	if [[ ${MD5IRF} == ${MD5TESTIRF} ]]; then
		echo "IRFinder text output passes MD5 test"
	else
		echo "IRFinder text output failed MD5 test"
	fi

	MD5COV=`md5sum ${SAMPLECOV} | cut -d\t  -f1`
	MD5TESTCOV=`md5sum ${TESTCOV} | cut -d\t  -f1`
	if [[ ${MD5COV} == ${MD5TESTCOV} ]]; then
		echo "IRFinder COV output passes MD5 test"
	else
		echo "IRFinder COV output failed MD5 test"
	fi
}

if [[ ! -x ${BINDIR}/nxtirf ]]; then
	echo "NxtIRF executable not found. Ensure ${PWD}/${BINDIR}/nxtirf exists. Exiting..."
else
	if [[ ! -d ${TMPDIR} ]]; then
		mkdir ${TMPDIR}
		# echo "${TMPDIR} created"

		run_tests

		rm -rf ${TMPDIR}
		# echo "${TMPDIR} removed"
	else
		run_tests
		rm -f ${TESTIRF}
		rm -f ${TESTCOV}
	fi
fi
