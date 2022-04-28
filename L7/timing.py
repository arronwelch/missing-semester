import time, random
n = random.randint(1, 10) * 100 

# Get current time
start = time.time()

# Do some work
print("Sleeping for {} s".format(n/1000))
time.sleep(n/1000) # sleep {n/1000} s

# Compute time between start and now
print(time.time() - start)

# python timing.py
