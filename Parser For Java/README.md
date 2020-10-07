The parser built in this milestone is a parser for Java version 8 programs. We used ANTLR4 to
describe the productions used to generate the parsing code in the language Python3.
We used Python pydot to generate the dot file to be used for constructing the AST. We then used
graphviz package for Python3 to visualize the AST from the dot file.

To get antlr4, we need to run the command:
						sudo apt install antlr4

To get antlr4 package for python3, we run:
						pip3 install antlr4 − python3 − runtime
To get python3 packages for graphviz and pydot, we run the commands pip3 install graphviz and
						pip3 install pydot respectively.
References :
https://www.antlr.org/
https://pypi.org/project/pydot/
https://github.com/antlr/codebuff/blob/master/grammars/org/antlr


We need to move to the milestone directory. To build the parser, we need to run the bash script:
													bash make.sh
In order to run the parser for an input in the tests directory, we run
										bash run.sh inputf ile outputf ile [−h] −v
inputfile is the name of the input java program present in the directory tests and not tests/inputfile .
outputfile is the name of the output file. After running the parser, the output will be saved as out/DOT/outputfile.dot and out/PNG/outputf ile.png.
Here, the options -h and -v are optional. We use -h to help the user with instructions and -v to get an explanation for the AST construction.
