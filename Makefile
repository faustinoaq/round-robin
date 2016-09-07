.PHONY: compile benchmark ruby python java crystal clean

benchmark: compile
	/usr/bin/bash Benchmark/benchmark.sh

compile: java crystal

ruby:
	ruby RoundRobin.rb

python:
	python -m compileall RoundRobin.py

java:
	javac Java/RoundRobin.java

crystal:
	crystal build -s RoundRobin.cr --release

clean:
	rm -rf RoundRobin __pycache__ Java/*.class *.txt *.dat
