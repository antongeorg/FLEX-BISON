/* Onoma arxeiou:	FL.l
   Perigrafh:		Lektikos analyths me xrhsh tou ergaleiou Flex pou anagnwrizei:Integer,Comments,
                        String literal,String,Imaginary number kai floating point literal
   Syggrafeas:		Ergasthrio Metaglwttistwn, Tmhma E7 Pempti 10-12,Antwnios Gewrgakopoulos cs131107
                        Gewrgios-Spyridwn Kasnis cs131016 
   Odhgies ekteleshs:	flex -o FL.c FL.l
			gcc -o FL FL.c
			./FL
*/

%option noyywrap
%x error
%x string
%x comment
%x character 

/* Kwdikas C gia orismo twn apaitoumenwn header files kai twn metablhtwn.
   Otidhpote anamesa sta %{ kai %} metaferetai autousio sto arxeio C pou
   tha dhmiourghsei to Flex. */

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
//#define YYSTYPE double
#include "project.tab.h"

/* Header file pou periexei lista me ola ta tokens(onomata anagnwristikwn tis glwssas) */
//#include "heading.h"

/* Orismos metrhth trexousas grammhs */
int line=1;

/* Synartisi emfanisis lektikwn lathwn*/
int yyerror(const char *s);


%}

/* Onomata kai antistoixoi orismoi (ypo morfh kanonikhs ekfrashs).
   Meta apo auto, mporei na ginei xrhsh twn onomatwn (aristera) anti twn,
   synhthws idiaiterws makrsokelwn kai dysnohtwn, kanonikwn ekfrasewn */
DELIMITERS  [\t]+
AKERAIOI  ([0][Bb][01]+)|([0]+)|([1-9]+[0-9]*)
SXOLIA [#].*
LEKTIKA (["].*["])|(['].*['])
ANAGNWRISTIKO [_A-Za-z]+[_A-Za-z0-9]*
ANAGN ([_A-Za-z]+[_A-Za-z0-9]*[\s]+)*
IMAGINARY  ([.]?[0-9]+[e]?[0-9]*[jJ]?)|([0-9]+[.]?[0-9]*[e]?[0-9]*[jJ]?)
KINITIS  ([0-9]+[eE]?[-+0-9][0-9]*)|([0-9]+[.][0-9]*[eE]?[-+0-9]?[0-9]*)|([.][eE]?[-+0-9][0-9]*)
TOKEN ([,]{ANAGNWRISTIKO})*

/*Akolouthoun ta onomata kai oi kanonikes ekfraseis me ta errror */

AKERAIOI_ERROR ([1][Bb][01]+)|([0][1-9]+)|([01][Bb][01]*[2-9]+[01]*)



LEKTIKA_ERROR (["].*['])|(['].*["])

ANAGNWRISTIKA_ERROR [0-9]+{ANAGNWRISTIKO}
 
IMAGINARY_ERROR [jJ]{IMAGINARY}
IMAGINARY_ERROR2  ([.]{2}[0-9]+[e]?[0-9]*[jJ]?)|([0-9]+[.]{2}[0-9]*[e]?[0-9]*[jJ]?)
IMAGINARY_ERROR3  ([.]?[0-9]+[e]{2}[0-9]*[jJ]?)|([0-9]+[.]?[0-9]*[e]{2}[0-9]*[jJ]?)

KINITIS_ERROR   [eE]{KINITIS}|{KINITIS}[eE]
KINITIS_ERROR2  ([0-9]+[eE]?[-+0-9][0-9]*)|([0-9]+[.]{2}[0-9]*[eE]?[-+0-9]?[0-9]*)|([.]{2}[eE]?[-+0-9][0-9]*)
KINITIS_ERROR3 ([0-9]+[eE]{2}[-+0-9][0-9]*)|([0-9]+[.][0-9]*[eE]{2}[-+0-9]?[0-9]*)|([.][eE]{2}[-+0-9][0-9]*)

SXOLIA_ERROR .+{SXOLIA} 

%%

 /* Gia kathe pattern (aristera) pou tairiazei ekteleitai o antistoixos kwdikas mesa  sta agkistra.H entoli return epitrepei thn epistrofh mias arithmhtikhs timhs mesw ths synarthshs yylex() */
{DELIMITERS} { }
"+" 	{return PLUS;}
"-" 	{return MINUS;}
"*" 	{return TIMES;}
"/" 	{return DIVIDE;}
"^"	{return POWER;}
"(" 	{return LEFT;}
")" 	{return RIGHT;}
"[" 	{return LFT;}
"]"	{return RGHT;}
","	{return KOMA;}
"="	{return ISON;}
":"     {return ANO;}
"del"   {return DEL;}
"return" {return RETURN;}
"len"   {return LEN;}
"cmp" 	{return CMP;}
"print" {return PRINT;}
"def" 	{return DEF;}
"\n"    {return END;}


{LEKTIKA} { return LEKTIKA; }
{ANAGNWRISTIKO} { return ANAGNWRISTIKO; }
{TOKEN} {return TOKEN; }





<error>[ \t]	{BEGIN(0);}        /*se periptwsi pou dwsi tab */ 
<error>[\n]     {BEGIN(0);line++;} /*se periptwsi pou to error einai newline */
<error>.	{}

<<EOF>> { exit(0);}





