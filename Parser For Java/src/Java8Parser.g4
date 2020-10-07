parser grammar Java8Parser;

options {
    tokenVocab=Java8Lexer;
}

types
    :   primitiveType
    |   referenceType
    ;

primitiveType
	:	annotation* numericType
	|	annotation* BOOLEAN
	;

numericType
	:	integralType
	|	floatingPointType
	;

integralType
	:	BYTE
	|	SHORT
	|	INT
	|	LONG
	|	CHAR
	;

floatingPointType
	:	FLOAT
	|	DOUBLE
	;

referenceType
	:	classType
	|	typeVariable
	|	arrayType
	;

classType
	:	annotation* Identifier typeArguments?
	|	classType DOT annotation* Identifier typeArguments?
	;


typeVariable
	:	annotation* Identifier
	;

arrayType
	:	primitiveType dims
	|	classType dims
	|	typeVariable dims
	;

dims
	:	annotation* LBRACK RBRACK (annotation* LBRACK RBRACK)*
	;

typeParameter
	:	typeParameterModifier* Identifier typeBound?
	;

typeParameterModifier
	:	annotation
	;

typeBound
	:	EXTENDS typeVariable
	|	EXTENDS classType additionalBound*
	;

additionalBound
	:	BITAND classType
	;

typeArguments
	:	LT typeArgumentList GT
	;

typeArgumentList
	:	typeArgument (COMMA typeArgument)*
	;

typeArgument
	:	referenceType
	|	wildcard
	;

wildcard
	:	annotation* QUESTION wildcardBounds?
	;

wildcardBounds
	:	EXTENDS referenceType
	|	SUPER referenceType
	;

packageName
	:	Identifier
	|	packageName DOT Identifier
	;

typeName
	:	Identifier
	|	packageOrTypeName DOT Identifier
	;

packageOrTypeName
	:	Identifier
	|	packageOrTypeName DOT Identifier
	;

expressionName
	:	Identifier
	|	ambiguousName DOT Identifier
	;

methodName
	:	Identifier
	;

ambiguousName
	:	Identifier
	|	ambiguousName DOT Identifier
	;

compilationUnit
	:	packageDeclaration? importDeclaration* typeDeclaration* EOF
	;

packageDeclaration
	:	packageModifier* PACKAGE packageName SEMI
	;

packageModifier
	:	annotation
	;

importDeclaration
	:	singleTypeImportDeclaration
	|	typeImportOnDemandDeclaration
	|	singleStaticImportDeclaration
	|	staticImportOnDemandDeclaration
	;

singleTypeImportDeclaration
	:	IMPORT typeName SEMI
	;

typeImportOnDemandDeclaration
	:	IMPORT packageOrTypeName DOT MUL SEMI
	;

singleStaticImportDeclaration
	:	IMPORT STATIC typeName DOT Identifier SEMI
	;

staticImportOnDemandDeclaration
	:	IMPORT STATIC typeName DOT MUL SEMI
	;

typeDeclaration
	:	classDeclaration
	|	interfaceDeclaration
	|	SEMI
	;

classDeclaration
	:	normalClassDeclaration
	|	enumDeclaration
	;

normalClassDeclaration
	:	classModifier* CLASS Identifier typeParameters? superclass? superinterfaces? classBody
	;

classModifier
	:	annotation
	|	PUBLIC
	|	PROTECTED
	|	PRIVATE
	|	ABSTRACT
	|	STATIC
	|	FINAL
	|	STRICTFP
	;

typeParameters
	:	LT typeParameterList GT
	;

typeParameterList
	:	typeParameter (COMMA typeParameter)*
	;

superclass
	:	EXTENDS classType
	;

superinterfaces
	:	IMPLEMENTS interfaceTypeList
	;

interfaceTypeList
	:	classType (COMMA classType)*
	;

classBody
	:	LBRACE classBodyDeclaration* RBRACE
	;

classBodyDeclaration
	:	classMemberDeclaration
	|	instanceInitializer
	|	staticInitializer
	|	constructorDeclaration
	;

classMemberDeclaration
	:	fieldDeclaration
	|	methodDeclaration
	|	classDeclaration
	|	interfaceDeclaration
	|	SEMI
	;

fieldDeclaration
	:	fieldModifier* unannType variableDeclaratorList SEMI
	;

fieldModifier
	:	annotation
	|	PUBLIC
	|	PROTECTED
	|	PRIVATE
	|	STATIC
	|	FINAL
	|	TRANSIENT
	|	VOLATILE
	;

variableDeclaratorList
	:	variableDeclarator (COMMA variableDeclarator)*
	;

variableDeclarator
	:	variableDeclaratorId (ASSIGN variableInitializer)?
	;

variableDeclaratorId
	:	Identifier dims?
	;

variableInitializer
	:	expression
	|	arrayInitializer
	;

unannType
	:	unannPrimitiveType
	|	unannReferenceType
	;

unannPrimitiveType
	:	numericType
	|	'boolean'
	;

unannReferenceType
	:	unannClassOrInterfaceType
	|	unannTypeVariable
	|	unannArrayType
	;

unannClassOrInterfaceType
	:	(	unannClassTypeTempExceptUnannClassOrInterfaceType
		|	unannInterfaceTypeTempExceptUnannClassOrInterfaceType
		)
		(	unannClassTypeTempUnannClassOrInterfaceType
		|	unannInterfaceTypeTempUnannClassOrInterfaceType
		)*
	;

unannClassType
	:	Identifier typeArguments?
	|	unannClassOrInterfaceType DOT annotation* Identifier typeArguments?
	;

unannClassTypeTempUnannClassOrInterfaceType
	:	DOT annotation* Identifier typeArguments?
	;

unannClassTypeTempExceptUnannClassOrInterfaceType
	:	Identifier typeArguments?
	;

unannInterfaceType
	:	unannClassType
	;

unannInterfaceTypeTempUnannClassOrInterfaceType
	:	unannClassTypeTempUnannClassOrInterfaceType
	;

unannInterfaceTypeTempExceptUnannClassOrInterfaceType
	:	unannClassTypeTempExceptUnannClassOrInterfaceType
	;

unannTypeVariable
	:	Identifier
	;

unannArrayType
	:	unannPrimitiveType dims
	|	unannClassOrInterfaceType dims
	|	unannTypeVariable dims
	;

methodDeclaration
	:	methodModifier* methodHeader methodBody
	;

methodModifier
	:	annotation
	|	PUBLIC
	|	PROTECTED
	|	PRIVATE
	|	ABSTRACT
	|	STATIC
	|	FINAL
	|	SYNCHRONIZED
	|	NATIVE
	|	STRICTFP
	;

methodHeader
	:	result methodDeclarator throws_?
	|	typeParameters annotation* result methodDeclarator throws_?
	;

result
	:	unannType
	|	VOID
	;

methodDeclarator
	:	Identifier LPAREN formalParameterList? RPAREN dims?
	;

formalParameterList
	:	receiverParameter
	|	formalParameters COMMA lastFormalParameter
	|	lastFormalParameter
	;

formalParameters
	:	formalParameter (COMMA formalParameter)*
	|	receiverParameter (COMMA formalParameter)*
	;

formalParameter
	:	variableModifier* unannType variableDeclaratorId
	;

variableModifier
	:	annotation
	|	FINAL
	;

lastFormalParameter
	:	variableModifier* unannType annotation* ELLIPSIS variableDeclaratorId
	|	formalParameter
	;

receiverParameter
	:	annotation* unannType (Identifier DOT)? THIS
	;

throws_
	:	THROWS exceptionTypeList
	;

exceptionTypeList
	:	exceptionType (COMMA exceptionType)*
	;

exceptionType
	:	classType
	|	typeVariable
	;

methodBody
	:	block
	|	SEMI
	;

instanceInitializer
	:	block
	;

staticInitializer
	:	STATIC block
	;

constructorDeclaration
	:	constructorModifier* constructorDeclarator throws_? constructorBody
	;

constructorModifier
	:	annotation
	|	PUBLIC
	|	PROTECTED
	|	PRIVATE
	;

constructorDeclarator
	:	typeParameters? simpleTypeName LPAREN formalParameterList? RPAREN
	;

simpleTypeName
	:	Identifier
	;

constructorBody
	:	LBRACE explicitConstructorInvocation? blockStatements? RBRACE
	;

explicitConstructorInvocation
	:	typeArguments? THIS LPAREN argumentList? RPAREN SEMI
	|	typeArguments? SUPER LPAREN argumentList? RPAREN SEMI
	|	expressionName DOT typeArguments? SUPER LPAREN argumentList? RPAREN SEMI
	|	primary DOT typeArguments? SUPER LPAREN argumentList? RPAREN SEMI
	;

enumDeclaration
	:	classModifier* ENUM Identifier superinterfaces? enumBody
	;

enumBody
	:	LBRACE enumConstantList? COMMA? enumBodyDeclarations? RBRACE
	;

enumConstantList
	:	enumConstant (COMMA enumConstant)*
	;

enumConstant
	:	enumConstantModifier* Identifier (LPAREN argumentList? RPAREN)? classBody?
	;

enumConstantModifier
	:	annotation
	;

enumBodyDeclarations
	:	SEMI classBodyDeclaration*
	;

interfaceDeclaration
	:	normalInterfaceDeclaration
	|	annotationTypeDeclaration
	;

normalInterfaceDeclaration
	:	interfaceModifier* INTERFACE Identifier typeParameters? extendsInterfaces? interfaceBody
	;

interfaceModifier
	:	annotation
	|	PUBLIC
	|	PROTECTED
	|	PRIVATE
	|	ABSTRACT
	|	STATIC
	|	STRICTFP
	;

extendsInterfaces
	:	EXTENDS interfaceTypeList
	;

interfaceBody
	:	LBRACE interfaceMemberDeclaration* RBRACE
	;

interfaceMemberDeclaration
	:	constantDeclaration
	|	interfaceMethodDeclaration
	|	classDeclaration
	|	interfaceDeclaration
	|	SEMI
	;

constantDeclaration
	:	constantModifier* unannType variableDeclaratorList SEMI
	;

constantModifier
	:	annotation
	|	PUBLIC
	|	STATIC
	|	FINAL
	;

interfaceMethodDeclaration
	:	interfaceMethodModifier* methodHeader methodBody
	;

interfaceMethodModifier
	:	annotation
	|	PUBLIC
	|	ABSTRACT
	|	DEFAULT
	|	STATIC
	|	STRICTFP
	;

annotationTypeDeclaration
	:	interfaceModifier* AT INTERFACE Identifier annotationTypeBody
	;

annotationTypeBody
	:	LBRACE annotationTypeMemberDeclaration* RBRACE
	;

annotationTypeMemberDeclaration
	:	annotationTypeElementDeclaration
	|	constantDeclaration
	|	classDeclaration
	|	interfaceDeclaration
	|	SEMI
	;

annotationTypeElementDeclaration
	:	annotationTypeElementModifier* unannType Identifier LPAREN RPAREN dims? defaultValue? SEMI
	;

annotationTypeElementModifier
	:	annotation
	|	PUBLIC
	|	ABSTRACT
	;

defaultValue
	:	DEFAULT elementValue
	;

annotation
	:	normalAnnotation
	|	markerAnnotation
	|	singleElementAnnotation
	;

normalAnnotation
	:	AT typeName LPAREN elementValuePairList? RPAREN
	;

elementValuePairList
	:	elementValuePair (COMMA elementValuePair)*
	;

elementValuePair
	:	Identifier ASSIGN elementValue
	;

elementValue
	:	conditionalExpression
	|	elementValueArrayInitializer
	|	annotation
	;

elementValueArrayInitializer
	:	LBRACE elementValueList? COMMA? RBRACE
	;

elementValueList
	:	elementValue (COMMA elementValue)*
	;

markerAnnotation
	:	AT typeName
	;

singleElementAnnotation
	:	AT typeName LPAREN elementValue RPAREN
	;

arrayInitializer
	:	LBRACE variableInitializerList? COMMA? RBRACE
	;

variableInitializerList
	:	variableInitializer (COMMA variableInitializer)*
	;

block
	:	LBRACE blockStatements? RBRACE
	;

blockStatements
	:	blockStatement+
	;

blockStatement
	:	localVariableDeclarationStatement
	|	classDeclaration
	|	statement
	;

localVariableDeclarationStatement
	:	localVariableDeclaration SEMI
	;

localVariableDeclaration
	:	variableModifier* unannType variableDeclaratorList
	;

statement
	:	statementWithoutTrailingSubstatement
	|	labeledStatement
	|	ifThenStatement
	|	ifThenElseStatement
	|	whileStatement
	|	forStatement
	;

statementNoShortIf
	:	statementWithoutTrailingSubstatement
	|	labeledStatementNoShortIf
	|	ifThenElseStatementNoShortIf
	|	whileStatementNoShortIf
	|	forStatementNoShortIf
	;

statementWithoutTrailingSubstatement
	:	block
	|	emptyStatement
	|	expressionStatement
	|	assertStatement
	|	switchStatement
	|	doStatement
	|	breakStatement
	|	continueStatement
	|	returnStatement
	|	synchronizedStatement
	|	throwStatement
	|	tryStatement
	;

emptyStatement
	:	SEMI
	;

labeledStatement
	:	Identifier COLON statement
	;

labeledStatementNoShortIf
	:	Identifier COLON statementNoShortIf
	;

expressionStatement
	:	statementExpression SEMI
	;

statementExpression
	:	assignment
	|	preIncrementExpression
	|	preDecrementExpression
	|	postIncrementExpression
	|	postDecrementExpression
	|	methodInvocation
	|	classInstanceCreationExpression
	;

ifThenStatement
	:	IF LPAREN expression RPAREN statement
	;

ifThenElseStatement
	:	IF LPAREN expression RPAREN statementNoShortIf ELSE statement
	;

ifThenElseStatementNoShortIf
	:	IF LPAREN expression RPAREN statementNoShortIf ELSE statementNoShortIf
	;

assertStatement
	:	ASSERT expression SEMI
	|	ASSERT expression COLON expression SEMI
	;

switchStatement
	:	SWITCH LPAREN expression RPAREN switchBlock
	;

switchBlock
	:	LBRACE switchBlockStatementGroup* switchLabel* RBRACE
	;

switchBlockStatementGroup
	:	switchLabels blockStatements
	;

switchLabels
	:	switchLabel switchLabel*
	;

switchLabel
	:	'case' constantExpression COLON
	|	'case' enumConstantName COLON
	|	DEFAULT COLON
	;

enumConstantName
	:	Identifier
	;

whileStatement
	:	WHILE LPAREN expression RPAREN statement
	;

whileStatementNoShortIf
	:	WHILE LPAREN expression RPAREN statementNoShortIf
	;

doStatement
	:	DO statement WHILE LPAREN expression RPAREN SEMI
	;

forStatement
	:	basicForStatement
	|	enhancedForStatement
	;

forStatementNoShortIf
	:	basicForStatementNoShortIf
	|	enhancedForStatementNoShortIf
	;

basicForStatement
	:	FOR LPAREN forInit? SEMI expression? SEMI forUpdate? RPAREN statement
	;

basicForStatementNoShortIf
	:	FOR LPAREN forInit? SEMI expression? SEMI forUpdate? RPAREN statementNoShortIf
	;

forInit
	:	statementExpressionList
	|	localVariableDeclaration
	;

forUpdate
	:	statementExpressionList
	;

statementExpressionList
	:	statementExpression (COMMA statementExpression)*
	;

enhancedForStatement
	:	FOR LPAREN variableModifier* unannType variableDeclaratorId COLON expression RPAREN statement
	;

enhancedForStatementNoShortIf
	:	FOR LPAREN variableModifier* unannType variableDeclaratorId COLON expression RPAREN statementNoShortIf
	;

breakStatement
	:	BREAK Identifier? SEMI
	;

continueStatement
	:	CONTINUE Identifier? SEMI
	;

returnStatement
	:	RETURN expression? SEMI
	;

throwStatement
	:	THROW expression SEMI
	;

synchronizedStatement
	:	SYNCHRONIZED LPAREN expression RPAREN block
	;

tryStatement
	:	TRY block catches
	|	TRY block catches? finally_
	|	tryWithResourcesStatement
	;

catches
	:	catchClause catchClause*
	;

catchClause
	:	CATCH LPAREN catchFormalParameter RPAREN block
	;

catchFormalParameter
	:	variableModifier* catchType variableDeclaratorId
	;

catchType
	:	unannClassType (BITOR classType)*
	;

finally_
	:	FINALLY block
	;

tryWithResourcesStatement
	:	TRY resourceSpecification block catches? finally_?
	;

resourceSpecification
	:	LPAREN resourceList SEMI? RPAREN
	;

resourceList
	:	resource (SEMI resource)*
	;

resource
	:	variableModifier* unannType variableDeclaratorId ASSIGN expression
	;

primary
	:	(	primaryNoNewArrayTempExceptPrimary
		|	arrayCreationExpression
		)
		(	primaryNoNewArrayTempPrimary
		)*
	;

primaryNoNewArray
	:	Literal
	|	typeName (LBRACK RBRACK)* DOT CLASS
	|	VOID DOT CLASS
	|	THIS
	|	typeName DOT THIS
	|	LPAREN expression RPAREN
	|	classInstanceCreationExpression
	|	fieldAccess
	|	arrayAccess
	|	methodInvocation
	|	methodReference
	;

primaryNoNewArrayTempArrayAccess
	:
	;

primaryNoNewArrayTempExceptArrayAccess
	:	Literal
	|	typeName (LBRACK RBRACK)* DOT CLASS
	|	VOID DOT CLASS
	|	THIS
	|	typeName DOT THIS
	|	LPAREN expression RPAREN
	|	classInstanceCreationExpression
	|	fieldAccess
	|	methodInvocation
	|	methodReference
	;

primaryNoNewArrayTempPrimary
	:	classInstanceCreationExpressionTempPrimary
	|	fieldAccessTempPrimary
	|	arrayAccessTempPrimary
	|	methodInvocationTempPrimary
	|	methodReferenceTempPrimary
	;

primaryNoNewArrayTempPrimaryTempArrayAccessTempPrimary
	:
	;

primaryNoNewArrayTempPrimaryTempExceptArrayAccessTempPrimary
	:	classInstanceCreationExpressionTempPrimary
	|	fieldAccessTempPrimary
	|	methodInvocationTempPrimary
	|	methodReferenceTempPrimary
	;

primaryNoNewArrayTempExceptPrimary
	:	Literal
	|	typeName (LBRACK RBRACK)* DOT CLASS
	|	unannPrimitiveType (LBRACK RBRACK)* DOT CLASS
	|	VOID DOT CLASS
	|	THIS
	|	typeName DOT THIS
	|	LPAREN expression RPAREN
	|	classInstanceCreationExpressionTempExceptPrimary
	|	fieldAccessTempExceptPrimary
	|	arrayAccessTempExceptPrimary
	|	methodInvocationTempExceptPrimary
	|	methodReferenceTempExceptPrimary
	;

primaryNoNewArrayTempExceptPrimaryTempArrayAccessTempExceptPrimary
	:
	;

primaryNoNewArrayTempExceptPrimaryTempExceptArrayAccessTempExceptPrimary
	:	Literal
	|	typeName (LBRACK RBRACK)* DOT CLASS
	|	unannPrimitiveType (LBRACK RBRACK)* DOT CLASS
	|	VOID DOT CLASS
	|	THIS
	|	typeName DOT THIS
	|	LPAREN expression RPAREN
	|	classInstanceCreationExpressionTempExceptPrimary
	|	fieldAccessTempExceptPrimary
	|	methodInvocationTempExceptPrimary
	|	methodReferenceTempExceptPrimary
	;

classInstanceCreationExpression
	:	NEW typeArguments? annotation* Identifier (DOT annotation* Identifier)* typeArgumentsOrDiamond? LPAREN argumentList? RPAREN classBody?
	|	expressionName DOT NEW typeArguments? annotation* Identifier typeArgumentsOrDiamond? LPAREN argumentList? RPAREN classBody?
	|	primary DOT NEW typeArguments? annotation* Identifier typeArgumentsOrDiamond? LPAREN argumentList? RPAREN classBody?
	;

classInstanceCreationExpressionTempPrimary
	:	DOT NEW typeArguments? annotation* Identifier typeArgumentsOrDiamond? LPAREN argumentList? RPAREN classBody?
	;

classInstanceCreationExpressionTempExceptPrimary
	:	NEW typeArguments? annotation* Identifier (DOT annotation* Identifier)* typeArgumentsOrDiamond? LPAREN argumentList? RPAREN classBody?
	|	expressionName DOT NEW typeArguments? annotation* Identifier typeArgumentsOrDiamond? LPAREN argumentList? RPAREN classBody?
	;

typeArgumentsOrDiamond
	:	typeArguments
	|	LT GT
	;

fieldAccess
	:	primary DOT Identifier
	|	SUPER DOT Identifier
	|	typeName DOT SUPER DOT Identifier
	;

fieldAccessTempPrimary
	:	DOT Identifier
	;

fieldAccessTempExceptPrimary
	:	SUPER DOT Identifier
	|	typeName DOT SUPER DOT Identifier
	;

arrayAccess
	:	(	expressionName LBRACK expression RBRACK
		|	primaryNoNewArrayTempExceptArrayAccess LBRACK expression RBRACK
		)
		(	primaryNoNewArrayTempArrayAccess LBRACK expression RBRACK
		)*
	;

arrayAccessTempPrimary
	:	(	primaryNoNewArrayTempPrimaryTempExceptArrayAccessTempPrimary LBRACK expression RBRACK
		)
		(	primaryNoNewArrayTempPrimaryTempArrayAccessTempPrimary LBRACK expression RBRACK
		)*
	;

arrayAccessTempExceptPrimary
	:	(	expressionName LBRACK expression RBRACK
		|	primaryNoNewArrayTempExceptPrimaryTempExceptArrayAccessTempExceptPrimary LBRACK expression RBRACK
		)
		(	primaryNoNewArrayTempExceptPrimaryTempArrayAccessTempExceptPrimary LBRACK expression RBRACK
		)*
	;

methodInvocation
	:	methodName LPAREN argumentList? RPAREN
	|	typeName DOT typeArguments? Identifier LPAREN argumentList? RPAREN
	|	expressionName DOT typeArguments? Identifier LPAREN argumentList? RPAREN
	|	primary DOT typeArguments? Identifier LPAREN argumentList? RPAREN
	|	SUPER DOT typeArguments? Identifier LPAREN argumentList? RPAREN
	|	typeName DOT SUPER DOT typeArguments? Identifier LPAREN argumentList? RPAREN
	;

methodInvocationTempPrimary
	:	DOT typeArguments? Identifier LPAREN argumentList? RPAREN
	;

methodInvocationTempExceptPrimary
	:	methodName LPAREN argumentList? RPAREN
	|	typeName DOT typeArguments? Identifier LPAREN argumentList? RPAREN
	|	expressionName DOT typeArguments? Identifier LPAREN argumentList? RPAREN
	|	SUPER DOT typeArguments? Identifier LPAREN argumentList? RPAREN
	|	typeName DOT SUPER DOT typeArguments? Identifier LPAREN argumentList? RPAREN
	;

argumentList
	:	expression (COMMA expression)*
	;

methodReference
	:	expressionName COLONCOLON typeArguments? Identifier
	|	referenceType COLONCOLON typeArguments? Identifier
	|	primary COLONCOLON typeArguments? Identifier
	|	SUPER COLONCOLON typeArguments? Identifier
	|	typeName DOT SUPER COLONCOLON typeArguments? Identifier
	|	classType COLONCOLON typeArguments? NEW
	|	arrayType COLONCOLON NEW
	;

methodReferenceTempPrimary
	:	COLONCOLON typeArguments? Identifier
	;

methodReferenceTempExceptPrimary
	:	expressionName COLONCOLON typeArguments? Identifier
	|	referenceType COLONCOLON typeArguments? Identifier
	|	SUPER COLONCOLON typeArguments? Identifier
	|	typeName DOT SUPER COLONCOLON typeArguments? Identifier
	|	classType COLONCOLON typeArguments? NEW
	|	arrayType COLONCOLON NEW
	;

arrayCreationExpression
	:	NEW primitiveType dimExprs dims?
	|	NEW classType dimExprs dims?
	|	NEW primitiveType dims arrayInitializer
	|	NEW classType dims arrayInitializer
	;

dimExprs
	:	dimExpr dimExpr*
	;

dimExpr
	:	annotation* LBRACK expression RBRACK
	;

constantExpression
	:	expression
	;

expression
	:	lambdaExpression
	|	assignmentExpression
	;

lambdaExpression
	:	lambdaParameters ARROW lambdaBody
	;

lambdaParameters
	:	Identifier
	|	LPAREN formalParameterList? RPAREN
	|	LPAREN inferredFormalParameterList RPAREN
	;

inferredFormalParameterList
	:	Identifier (COMMA Identifier)*
	;

lambdaBody
	:	expression
	|	block
	;

assignmentExpression
	:	conditionalExpression
	|	assignment
	;

assignment
	:	leftHandSide assignmentOperator expression
	;

leftHandSide
	:	expressionName
	|	fieldAccess
	|	arrayAccess
	;

assignmentOperator
	:	ASSIGN
	|	MUL_ASSIGN
	|	DIV_ASSIGN
	|	MOD_ASSIGN
	|	ADD_ASSIGN
	|	SUB_ASSIGN
	|	LSHIFT_ASSIGN
	|	RSHIFT_ASSIGN
	|	URSHIFT_ASSIGN
	|	AND_ASSIGN
	|	XOR_ASSIGN
	|	OR_ASSIGN
	;

conditionalExpression
	:	conditionalOrExpression
	|	conditionalOrExpression QUESTION expression COLON conditionalExpression
	;

conditionalOrExpression
	:	conditionalAndExpression
	|	conditionalOrExpression OR conditionalAndExpression
	;

conditionalAndExpression
	:	inclusiveOrExpression
	|	conditionalAndExpression AND inclusiveOrExpression
	;

inclusiveOrExpression
	:	exclusiveOrExpression
	|	inclusiveOrExpression BITOR exclusiveOrExpression
	;

exclusiveOrExpression
	:	andExpression
	|	exclusiveOrExpression CARET andExpression
	;

andExpression
	:	equalityExpression
	|	andExpression BITAND equalityExpression
	;

equalityExpression
	:	relationalExpression
	|	equalityExpression EQUAL relationalExpression
	|	equalityExpression NE relationalExpression
	;

relationalExpression
	:	shiftExpression
	|	relationalExpression LT shiftExpression
	|	relationalExpression GT shiftExpression
	|	relationalExpression LE shiftExpression
	|	relationalExpression GE shiftExpression
	|	relationalExpression INSTANCEOF referenceType
	;

shiftExpression
	:	additiveExpression
	|	shiftExpression LT LT additiveExpression
	|	shiftExpression GT GT additiveExpression
	|	shiftExpression GT GT GT additiveExpression
	;

additiveExpression
	:	multiplicativeExpression
	|	additiveExpression ADD multiplicativeExpression
	|	additiveExpression SUB multiplicativeExpression
	;

multiplicativeExpression
	:	unaryExpression
	|	multiplicativeExpression MUL unaryExpression
	|	multiplicativeExpression DIV unaryExpression
	|	multiplicativeExpression MOD unaryExpression
	;

unaryExpression
	:	preIncrementExpression
	|	preDecrementExpression
	|	ADD unaryExpression
	|	SUB unaryExpression
	|	unaryExpressionNotPlusMinus
	;

preIncrementExpression
	:	INC unaryExpression
	;

preDecrementExpression
	:	DEC unaryExpression
	;

unaryExpressionNotPlusMinus
	:	postfixExpression
	|	TILDE unaryExpression
	|	EXCLAIM unaryExpression
	|	castExpression
	;

postfixExpression
	:	(	primary
		|	expressionName
		)
		(	postIncrementExpressionTempPostfixExpression
		|	postDecrementExpressionTempPostfixExpression
		)*
	;

postIncrementExpression
	:	postfixExpression INC
	;

postIncrementExpressionTempPostfixExpression
	:	INC
	;

postDecrementExpression
	:	postfixExpression DEC
	;

postDecrementExpressionTempPostfixExpression
	:	DEC
	;

castExpression
	:	LPAREN primitiveType RPAREN unaryExpression
	|	LPAREN referenceType additionalBound* RPAREN unaryExpressionNotPlusMinus
	|	LPAREN referenceType additionalBound* RPAREN lambdaExpression
	;
