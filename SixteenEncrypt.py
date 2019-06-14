'''
https://github.com/sym233/core-values-encoder/issues/8
'''

import logging
import random
from itertools import islice

logging.basicConfig(level=logging.DEBUG)
# 加密字典汉字
VALUES = '富强民主文明和谐自由平等公正法治爱国敬业诚信友善'

def valueEncode(word):
    return duo2values(hex2duo(str2utf8(word)))

def valueDecode(value):
    return utf82str(duo2hex(values2duo(value)))

def duo2values(duo):
    # 将列表中的十六进制数字替换为字典汉字
    value = ''.join([VALUES[2 * i] + VALUES[2 * i + 1] for i in duo])
    logging.debug('{} --> {}'.format(duo, value))
    return value

def values2duo(value):
    duo = []
    # 将字符串中含有加密字典汉字提取出来
    pureValue = [v for v in value if v in VALUES]
    # enumerate() 函数用于将一个可遍历的数据对象(如列表、元组或字符串)组合为一个索引序列，同时列出数据和数据下标，一般用在 for 循环当中。
    for i, v in enumerate(pureValue[::2]):
        index = VALUES.index(v)
        if index % 2 == 0:
            # 取整除，向下取整,转化为数字列表
            duo.append(index // 2)
    logging.debug('{} --> {}'.format(value, duo))
    return duo

def hex2duo(hexStr):
    # 将转化为十六进制的字符串以列表方式存储
    duo = []
    for h in hexStr:
        numH = int(h, 16)
        if numH < 10:
            duo.append(numH)
        elif random.random() < 0.5:
            duo.append(10)
            duo.append(numH - 10)
        else:
            duo.append(11)
            duo.append(numH - 6)
    logging.debug('{} --> {}'.format(hexStr, duo))
    return duo

def duo2hex(duo):
    hexList = []
    if duo[-1] >= 10:
        duo = duo[:-1]
    # 枚举完生成迭代
    lit = iter(enumerate(duo))
    for i, d in lit:
        if d < 10:
            hexList.append('{:X}'.format(d))
        elif d == 10:
            hexList.append('{:X}'.format(duo[i + 1] + 10))
            next(islice(lit, 1, 1), None)
        else:
            hexList.append('{:X}'.format(duo[i + 1] + 6))
            next(islice(lit, 1, 1), None)
    hexStr = ''.join(hexList)
    logging.debug('{} --> {}'.format(duo, hexStr))
    return hexStr

def str2utf8(Str):
    # 将字符串转化为十六进制
    utfStr = ''.join([i.encode('utf-8').hex().upper() for i in Str])
    logging.debug('{} --> {}'.format(Str, utfStr))
    return utfStr

def utf82str(utfStr):
    Str = bytearray.fromhex(utfStr).decode('utf-8')
    logging.debug('{} --> {}'.format(utfStr, Str))
    return Str


if __name__ == "__main__":
    print('encode')
    valueEncode('Hello:!~World测试')
    print('Decode')
    valueDecode('自由爱国公正平等公正诚信文明公正友善公正公正诚信平等和谐诚信富强文明民主法治友善爱国平等法治公正友善敬业法治文明公正友善公正公正自由诚信自由公正诚信民主平等爱国诚信民主友善爱国爱国诚信富强诚信平等敬业平等')