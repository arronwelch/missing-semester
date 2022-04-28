#!/usr/bin/env python3
import requests
from bs4 import BeautifulSoup

# This is a decorator that tells line_profiler
# that we want to analyze this function
@profile
def get_urls():
	response = request.get('https://missing.csail.mit.edu')
	s = BeautifulSoup(response.content, 'lxml')
	urls = []
	for url in s.find_all('a'):
		urls.append(url['href'])

if __name__ == '__main__':
	get_urls()

# python3 -m cProfile -s tottime urls.py | tac
