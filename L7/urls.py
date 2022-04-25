#!/usr/bin/env python3
from cProfile import Profile
from bs4 import BeautifulSoup
from requests import request

# This is a decorator that tells line_profiler
# that we want to analyze this function
@Profile
def get_urls():
	response = request.get('https://missing.csail.mit.edu')
	s = BeautifulSoup(response.content, 'lxml')
	urls = []
	for url in s.find_all('a'):
		urls.append(url['href'])

if __name__ == '__main__':
	get_urls()

# python3 -m cProfile -s tottime urls.py | tac
