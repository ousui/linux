import random


els = []

preffix = "2017cqks{}{}"

for i in range(8):
    p = i + 1
    els.append(preffix.format(p < 10 and "0" or "", p))


random.shuffle(els)

for el in els:
    print(el)
