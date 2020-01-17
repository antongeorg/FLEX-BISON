all:
	bison -d project.y
	flex project.l
	gcc -o project lex.yy.c project.tab.c -lfl -lm
	./project < input.txt > output.txt

clean:
	rm project.tab.c project.tab.h lex.yy.c project
