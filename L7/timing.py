import time

n = 500.0 
# Get current time
start = time.time()

# Do some work
print("Sleeping for {} s".format(n/1000))
time.sleep(n/1000)

# Compute time between start and now
print(time.time() - start)

# python timing.py
