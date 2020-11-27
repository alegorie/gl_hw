import os
import json

list_of_files = os.listdir()
print(list_of_files)
big_string = ''.join([open(file, "r").read().replace('\n', '') for file in list_of_files if file != 'CountTop.py'])
#with open('ea004ec6-a39d-4657-bf4e-c52506feb64a', 'r') as file:
#big_string = file.read().replace('\n', '')

number_of_replaces = big_string.count('}{')
big_string = big_string.replace("}{", "}splitter{", number_of_replaces)

prices = []
for messages in big_string.split('splitter'):
	messages = messages.replace("\'", "\"").replace(' ', '')
	messages = json.loads(messages)
	prices.append(messages['data']['price'])

print('Top prices are:')
if len(prices) >= 10:
	print(sorted(prices)[-10:])
else:
	print(sorted(prices)[::-1])