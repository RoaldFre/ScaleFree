all: optim

debug:
	#chpl game.chpl -o game --baseline --no-optimize --debug
	chpl game.chpl -o game --baseline --no-optimize --debug --serial --serial-forall --local

serial:
	chpl game.chpl -o game --optimize --fast --serial --serial-forall --local

optim:
	chpl game.chpl -o game --optimize --fast

test:
	chpl gameTest.chpl -o gameTest
