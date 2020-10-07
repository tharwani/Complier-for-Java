import ply.lex as lex
from ply.lex import TOKEN
import collections
import sys
tokens = (
    'IDENTIFIER',
    'LITERAL',
    'SEPERATOR',
    'OPERATOR',
    'COMMENT',
    'KEYWORD'
)

keywords = [
    'abstract',
    'assert',
    'boolean',
    'break',
    'byte',
    'case',
    'catch',
    'char',
    'class',
    'const',
    'continue',
    'default',
    'do',
    'double',
    'else',
    'enum',
    'extends',
    'final',
    'finally',
    'float',
    'for',
    'if',
    'goto',
    'implements',
    'import',
    'instanceof',
    'int',
    'interface',
    'long',
    'native',
    'new',
    'package',
    'private',
    'protected',
    'public',
    'return',
    'short',
    'static',
    'strictfp',
    'super',
    'switch',
    'synchronized',
    'this',
    'throw',
    'throws',
    'transient',
    'try',
    'void',
    'volatile',
    'while'
]

boolean_literals = [
    'true',
    'false'
]
null_literal = ['null']
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)
    
def t_whitespace(t):
    r'\s'
    pass

illegal = []

unicode_escape = r'\\u+[0-9a-fA-F]{4}'
lineTerminator = r'(\\[rn]|\r\n)'
octalEscape = r'(\\[0-7]{2})|(\\[0-7])|(\\[0-3][0-7]{2})'
escapeSequence = r'\\[btfrn\\\'\"]|'+octalEscape
singleCharacter = r'[^\r\n\'\\]|' + unicode_escape
stringCharacter = r'[^\r\n\"\\]|('+unicode_escape+r'|'+escapeSequence+')'

integerTypeSuffix = r'[lL]'
nonZeroDigit = r'[1-9]'
digit = r'(0|'+nonZeroDigit+r')'
underscores = r'(_+)'
digitOrUndersore = r'('+digit+r'|_)'
digitsAndUnderscores = r'('+digitOrUndersore+r'+)'
digits = r'(('+digit+digitsAndUnderscores+r'?'+digit+r')|'+digit+r')'
decimalNumeral = r'(('+nonZeroDigit+underscores+digits+r')|('+nonZeroDigit+digits+r'?)|0)'
decimalIntegerLiteral = decimalNumeral+integerTypeSuffix+r'?'
hexDigit = r'[0-9a-fA-F]'
hexDigitOrUnderscore = r'('+hexDigit+r'|_)'
hexDigitsAndUnderscore = r'('+hexDigitOrUnderscore+r'+)'
hexDigits = r'(('+hexDigit+hexDigitsAndUnderscore+r'?'+hexDigit+r')|'+hexDigit+r')'
hexNumeral = '(0[xX]'+hexDigits+r')'
hexIntegerLiteral = hexNumeral+integerTypeSuffix+r'?'
octalDigit = r'[0-7]'
octalDigitOrUnderscore = r'('+octalDigit+r'|_)'
octalDigitsAndUnderscores = r'('+octalDigitOrUnderscore+r'+)'
octalDigits = r'(('+octalDigit+octalDigitsAndUnderscores+r'?'+octalDigit+')|'+octalDigit+r')'
octalNumeral = r'(0('+underscores+octalDigits+r'|'+octalDigits+r'))'
octalIntegerLiteral = octalNumeral+integerTypeSuffix+r'?'
binaryDigit = r'[01]'
binaryDigitOrUnderscore = r'('+binaryDigit+r'|_)'
binaryDigitsAndUnderscores = r'('+binaryDigitOrUnderscore+r'+)'
binaryDigits = r'(('+binaryDigit+binaryDigitsAndUnderscores+r'?'+binaryDigit+')|'+binaryDigit+r')'
binaryNumeral = '(0[bB]'+binaryDigits+r')'
binaryIntegerLiteral = binaryNumeral+integerTypeSuffix+r'?'
floatTypeSuffix = r'[fFdD]'
sign = r'[+-]'
signedInteger = r'('+sign+r'?'+digits+r')'
exponentIndicator = r'[eE]'
exponentPart = r'('+exponentIndicator+signedInteger+r')'
decimalFloatingPointLiteral=r'(('+digits+r'\.'+digits+r'?'+exponentPart+r'?'+floatTypeSuffix+r'?)|(\.'+digits+r''+exponentPart+r'?'+floatTypeSuffix+r'?)|('+digits+exponentPart+floatTypeSuffix+r'?)|('+digits+exponentPart+floatTypeSuffix+r'?'+r'))'
binaryExponentIndicator=r'[pP]'
binaryexponent = r'('+binaryExponentIndicator+signedInteger+r')'
hexSignificand = r'((0[xX]'+hexDigits+r'?\.'+hexDigits+r')|('+hexNumeral+r'\.?))'
hexaDecimalFloatingPointLiteral = hexSignificand+binaryexponent+floatTypeSuffix+r'?'
FloatingPointLiteral = decimalFloatingPointLiteral+r'|'+hexaDecimalFloatingPointLiteral

literal = []
literal.append(FloatingPointLiteral)
literal.append(r'(\'('+singleCharacter+')\'|\'('+escapeSequence+')\')')
literal.append(r'(\"('+stringCharacter+')*\")')
literal.append(hexIntegerLiteral)
literal.append(binaryIntegerLiteral)
literal.append(octalIntegerLiteral)
literal.append(decimalIntegerLiteral)

@TOKEN('|'.join(literal))
def t_LITERAL(t):
    return t
def t_SEPERATOR(t):
    r'\(|\)|\{|\}|\[|\]|;|,|\.\.\.|\.|@|::'
    return t
def t_COMMENT(t):
    r'(/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/)|(//.*)'
    pass
    # return t
def t_OPERATOR(t):
    r'\>\>\>\=|\>\>\=|\<\<\=|\<\<|\-\>|\=\=|\>\=|\<\=|\!\=|&&|\|\||\+\+|\-\-|\+\=|\-\=|\*\=|/\=|&\=|\|\=|\^\=|%\=|\=|\<|\>|\!|~|\?|:|\+|\-|\*|/|&|\||\^|%'
    return t
def t_IDENTIFIER(t):
    r'\$?[a-zA-Z_][a-zA-Z_0-9]*'
    if t.value in keywords:
        t.type = 'KEYWORD'
    elif t.value in boolean_literals or t.value in null_literal:
        t.type = 'LITERAL'
    return t

def t_error(t):
    illegal.append([t.value[0],t.lineno])
    t.lexer.skip(1)

lexer = lex.lex()

if len(sys.argv)!=2:
    print("Provide the input correctly")
    exit()
f=open(sys.argv[1],'r')
# Give the lexer some input
lexer.input(f.read())
 # Tokenize
st = []
while True:
    tok = lexer.token()
    if not tok: 
        break      # No more input
    # print(tok)
    st.append((tok.value,tok.type))
sym = collections.Counter(st)
print("Lexeme,Token,Count")
for k in sym:
    print(k[0],k[1],sym[k],sep=',')
print("\nErrors\nLexeme,LineNo")
for i in range(len(illegal)):
    print(illegal[i][0],illegal[i][1],sep=',')