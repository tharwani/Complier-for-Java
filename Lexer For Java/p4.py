import ply.lex as lex
from ply.lex import TOKEN
import ply.yacc as yacc
import sys
import re
tokens = (
    'identifier',
    'title',
    'chapter',
    'section',
    'colon',
    'sentence_seperator',
    'seperator',
    'decimal',
    'float',
    'newline',
    'snewline',
    'whitespace'
)
def t_error(t):
    print("Error occured.")
    exit(0)

def t_snewline(t):
    r'\n\n+'
    return t

def t_newline(t):
    r'\n'
    return t

def t_whitespace(t):
    r'\s+'
    pass

def t_sentence_seperator(t):
    r'\.|\!|\?'
    return t

def t_seperator(t):
    r',|;'
    return t

integerTypeSuffix = r'[lL]'
nonZeroDigit = r'[1-9]'
digit = r'(0|'+nonZeroDigit+r')'
underscores = r'(_+)'
digitOrUndersore = r'('+digit+r'|_)'
digitsAndUnderscores = r'('+digitOrUndersore+r'+)'
digits = r'(('+digit+digitsAndUnderscores+r'?'+digit+r')|'+digit+r')'
decimalNumeral = r'(('+nonZeroDigit+underscores+digits+r')|('+nonZeroDigit+digits+r'?)|0)'

floatTypeSuffix = r'[fFdD]'
sign = r'[+-]'
signedInteger = r'('+sign+r'?'+digits+r')'
exponentIndicator = r'[eE]'
exponentPart = r'('+exponentIndicator+signedInteger+r')'
@TOKEN(r'(('+digits+r'\.'+digits+r'?'+exponentPart+r'?'+floatTypeSuffix+r'?)|(\.'+digits+r''+exponentPart+r'?'+floatTypeSuffix+r'?)|('+digits+exponentPart+floatTypeSuffix+r'?)|('+digits+exponentPart+floatTypeSuffix+r'?'+r'))')
def t_float(t):
    return t

@TOKEN(decimalNumeral+integerTypeSuffix+r'?')
def t_decimal(t):
    return t

def t_title(t):
    r'Title'
    return t

def t_chapter(t):
    r'Chapter'
    return t

def t_section(t):
    r'Section'
    return t

def t_colon(t):
    r':'
    return t

def t_identifier(t):
    r'[a-zA-Z]+'
    return t

lexer = lex.lex()
if len(sys.argv)!=2:
    print("Provide the input correctly")
    exit()
f=open(sys.argv[1],'r')
data=f.read()+"\n\n"
# Give the lexer some input
lexer.input(data)

chapter,section,paragraph,sentence,words,declarative,exclaimatory,interrogative = [0]*8
toc=[]
def p_error(p):
    print("Error occured.")
    exit(0)

title=''

def p_title(p):
    '''Title : thead tcontent'''
    p[0]=p[1]+p[2]

def p_title_content(p):
    '''tcontent : Chapter tcontent 
                | Chapter '''
    if len(p)==3:
        p[0]=p[1]+p[2]
    else:
        p[0]=p[1]

def p_title_head(p):
    '''thead : title colon group newline
             | title colon group snewline'''
    p[0]=p[1]+p[2]+' '+p[3]
    global title
    title = p[0]

def p_chapter(p):
    '''Chapter : chead scontent
               | chead scontent ccontent
               | chead ccontent'''
    if len(p)==4:
        p[0]=p[1]+p[2]+p[3]
    else:
        p[0]=p[1]+p[2]
    global chapter
    chapter+=1

def p_chapter_content(p):
    '''ccontent : Section ccontent
                | Section'''
    if len(p)==3:
        p[0]=p[1]+p[2]
    else:
        p[0]=p[1]
    # print(p[0])

def p_chapter_head(p):
    '''chead : chapter decimal colon group newline
             | chapter decimal colon group snewline'''
    p[0]=p[1]+' '+p[2]+p[3]+' '+p[4]
    global toc
    toc.append(p[0])

def p_section(p):
    '''Section : shead scontent'''
    p[0]=p[1]+p[2]
    global section
    section+=1

def p_section_head(p):
    '''shead : section float colon group newline
             | section float colon group snewline'''
    p[0]='  '+p[1]+' '+p[2]+p[3]+' '+p[4]
    global toc
    toc.append(p[0])
    # print(p[0])

def p_section_content(p):
    '''scontent : paragraph scontent
                | paragraph'''
    if len(p)==3:
        p[0]=p[1]+p[2]
    else:
        p[0]=p[1]
    global paragraph
    paragraph+=1
    # print(p[0])

def p_paragraph(p):
    '''paragraph : sentence paragraph
                 | sentence snewline'''
    p[0]=p[1]+p[2]
    # print(p[0])

def p_sentence(p):
    '''sentence : group sentence_seperator'''
    global declarative,exclaimatory,interrogative,sentence
    if p[2]=='.':
        declarative+=1
    elif p[2]=='!':
        exclaimatory+=1
    elif p[2]=='?':
        interrogative+=1
    p[0]=p[1]+p[2]
    sentence+=1

def p_word_group(p):
    '''group : word group 
             | word seperator group
             | word'''
    if len(p)==3:
        p[0]=p[1]+' '+p[2]
    elif len(p)==4:
        p[0]=p[1]+p[2]+' '+p[3]
    else:
        p[0]=p[1]

def p_word(p):
    '''word : identifier
            | decimal 
            | float'''
    p[0]=p[1]
    global words
    if re.match(r'[a-zA-Z]+',p[0]):
        words+=1
    
parser = yacc.yacc(start='Title')
result = parser.parse(data)
print(title)
print('Number of Chapters:',chapter)
print('Number of Sections:',section)
print('Number of Paragraphs:',paragraph)
print('Number of Sentences:',sentence)
print('     Number of Declarative Sentences:',declarative)
print('     Number of Exclaimatory Sentences:',exclaimatory)
print('     Number of Interrogative Sentences:',interrogative)
print('Number of Words:',words)
print('...')
print('Table of Contents:')
for k in toc:
    print(k)
