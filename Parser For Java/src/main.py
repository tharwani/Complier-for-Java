import pydot
import antlr4
from antlr4.InputStream import InputStream
from antlr4.FileStream import FileStream
from Java8Lexer import Java8Lexer
from Java8Parser import Java8Parser
import sys
from random import randrange
global num
global tokennum_to_token
from pprint import pprint
import argparse
tokennum_to_token = []
num = 0
global verbose_check
verbose_check = False
with open("Java8Parser.tokens",'r') as file:
    content = file.read()
    lines = content.split('\n')
    for line in lines:
        t = line.split('=')
        line_new = '='.join(piece for piece in t[:-1])
        # print(t)
        # print(line_new)
        tokennum_to_token.append(line_new)

def doit(expr,graph):
    global num
    global verbose_check
    # global doit 
    # if isinstance(expr,antlr4.tree.Tree.TerminalNode):
    if not (hasattr(expr, 'symbol')) and expr.getChildCount() == 0:
        return None
    if expr.getChildCount() == 0:    
        if(verbose_check):
            # print(str(expr.getText()) + '               (' + str(num) + ')')
            # print(expr.symbol.type)
            print("Node creation: "+expr.getText() )
        # pprint(vars(expr))
        # print(type(expr))
        temp = str(expr.getText()) + '        ' + str(tokennum_to_token[expr.symbol.type-1]) + '    (' + str(num) + ')'
        temp2 = str(expr.getText()) + '   (' + str(tokennum_to_token[expr.symbol.type-1]) + ')'
        n=pydot.Node(temp,label = temp2 )
        num += 1
        graph.add_node(n)
        return n
    else:
        # name = randrange(1000000000) 
        # print(expr.getText())
        # m=pydot.Node('pseudo' + str(name))
        # print(expr.getChildCount())
        if(expr.getChildCount() == 1):
            return doit(expr.getChild(0),graph)
        child1 = doit(expr.getChild(0),graph)   
        count = 0 
        get_count = expr.getChildCount()
        while child1 == None and count < get_count :
            count += 1
            child1 = doit(expr.getChild(count),graph)
        if child1==None:
            return child1    
        # count2 = 0
        for child_num in range(count + 1,expr.getChildCount()):
            n=doit(expr.getChild(child_num),graph)
            # print(child1,n)
            if(n != None):
                graph.add_edge(pydot.Edge(child1,n))
                if(verbose_check):
                    print("Edge added from: "+ str(child1.get_name()) + ' --> '+ str(n.get_name()) )
                # count2 += 1    
        # if(count2 == 0):
        #     return None
        return child1

def main(args):
    global verbose_check
    verbose_check = args.verbose
    infile = args.input
    outfile = args.out
    
    graph=pydot.Dot(graph_type='digraph')
    lexer = Java8Lexer(antlr4.FileStream(infile))
    stream = antlr4.CommonTokenStream(lexer)
    parser = Java8Parser(stream)
    tree = parser.compilationUnit()
    doit(tree,graph)
    graph.write(outfile+'.dot',format='dot')
    graph.write_png(outfile + '.png')
# global doit
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('input', metavar='i')
    parser.add_argument('out' , metavar='o')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()
    main(args)

