#!/usr/bin/env python3
#import np

def EratosthenesSieve():
    pass

def primes_below(limit):
    limit = int(limit)
    primes = np.ones(limit, dtype=np.int64)
    primes[[0, 1]] = 0
    for (i, isprime) in enumerate(primes):
        if isprime == 1:
            yield i
            primes[i * i:limit:i] = 0

if __name__ == '__main__':
    primes = EratosthenesSieve()
    print("Computing primes")
    i = 0
    for p in primes.below(1000):
        print(p)
