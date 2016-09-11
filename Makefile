.PHONY: compile benchmark python java crystal clean

benchmark: compile
	/bin/bash benchmark.sh

compile: python java crystal

python:
	python -m compileall RoundRobin.py

java:
	javac RoundRobin.java

crystal:
	crystal build RoundRobin.cr --release

clean:
	rm -rf RoundRobin __pycache__ *.class *.dat *.txt *.plt *.png
