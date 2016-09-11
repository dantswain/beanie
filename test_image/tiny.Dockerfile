# we just create a small container message.txt at /message.txt
# so that we can tag it and push it to the test registry

FROM busybox

COPY message.txt /message.txt
