merge:
	cat introduction.md method.md result.md discussion.md conclusion.md > merged.md
doc:
	pandoc merged.md -o merged.doc
tex: 
	pandoc merged.md -o merged.tex
clean:
	rm merged.*
