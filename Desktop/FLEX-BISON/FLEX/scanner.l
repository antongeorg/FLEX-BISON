/* Onoma arxeiou:	FL.l
   Perigrafh:		Lektikos analyths me xrhsh tou ergaleiou Flex pou anagnwrizei:Integer,Comments,
                        String literal,String,Imaginary number kai floating point literal
   Syggrafeas:		Ergasthrio Metaglwttistwn, Tmhma E7 Pempti 10-12,Antwnios Gewrgakopoulos cs131107
                        Gewrgios-Spyridwn Kasnis cs131016 
   Odhgies ekteleshs:	flex -o scanner.c scanner.l
			gcc -o scanner scanner.c
			./scanner input.txt output.txt
*/

%option noyywrap
%x error

/* Kwdikas C gia orismo twn apaitoumenwn header files kai twn metablhtwn.
   Otidhpote anamesa sta %{ kai %} metaferetai autousio sto arxeio C pou
   tha dhmiourghsei to Flex. */

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Header file pou periexei lista me ola ta tokens(onomata anagnwristikwn tis glwssas) */
#include "heading.h"

/* Orismos metrhth trexousas grammhs */
int line=1;

/* Synartisi emfanisis lektikwn lathwn*/
int yyerror(const char *s);


%}

/* Onomata kai antistoixoi orismoi (ypo morfh kanonikhs ekfrashs).
   Meta apo auto, mporei na ginei xrhsh twn onomatwn (aristera) anti twn,
   synhthws idiaiterws makrsokelwn kai dysnohtwn, kanonikwn ekfrasewn */

AKERAIOI  ([0][Bb][01]+)|([0]+)|([1-9]+[0-9]*)
SXOLIA [#].*
LEKTIKA (["].*["])|(['].*['])
ANAGNWRISTIKO [_A-Za-z]+[_A-Za-z0-9]*
IMAGINARY  ([.]?[0-9]+[e]?[0-9]*[jJ]?)|([0-9]+[.]?[0-9]*[e]?[0-9]*[jJ]?)
KINITIS  ([0-9]+[eE]?[-+0-9][0-9]*)|([0-9]+[.][0-9]*[eE]?[-+0-9]?[0-9]*)|([.][eE]?[-+0-9][0-9]*)

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

\n {line++;} /* otan dinoume newline(enter) o metritis line au3anetai kata ena */
{AKERAIOI} { return AKERAIOI; }
{SXOLIA} { return SXOLIA; }
{LEKTIKA} { return LEKTIKA; }
{ANAGNWRISTIKO} { return ANAGNWRISTIKO; }
{KINITIS} { return KINITIS; }
{IMAGINARY} { return IMAGINARY; }


{AKERAIOI_ERROR}  {yyerror("Integer Error"); BEGIN(error); return AKERAIOI_ERROR;}



{LEKTIKA_ERROR} {yyerror("String literals must start and end with quote or double quote !"); BEGIN(error); return LEKTIKA_ERROR;}

{ANAGNWRISTIKA_ERROR} {yyerror("String can't start with number"); BEGIN(error); return ANAGNWRISTIKA_ERROR;}

{KINITIS_ERROR} {yyerror("floating point literal can't start or end with e !"); BEGIN(error); return KINITIS_ERROR;}
{KINITIS_ERROR2} {yyerror("floating point literal can't have more than one dot!"); BEGIN(error); return KINITIS_ERROR2;}
{KINITIS_ERROR3} {yyerror("floating point literal can't have more than one e!"); BEGIN(error); return KINITIS_ERROR3;}

{IMAGINARY_ERROR} {yyerror("Imaginary numbers  can't start with j!"); BEGIN(error); return IMAGINARY_ERROR;}
{IMAGINARY_ERROR2} {yyerror("Imaginery numbers can't have more than one dot!"); BEGIN(error); return IMAGINARY_ERROR2;}
{IMAGINARY_ERROR3} {yyerror("Imaginary numbers can't have more than one e !"); BEGIN(error); return IMAGINARY_ERROR3;}


{SXOLIA_ERROR} {yyerror("Comments must begin with # "); BEGIN(error); return SXOLIA_ERROR;}

<error>[ \t]	{BEGIN(0);}        /*se periptwsi pou dwsi tab */ 
<error>[\n]     {BEGIN(0);line++;} /*se periptwsi pou to error einai newline */
<error>.	{}

<<EOF>> { exit(0);}
%%

/*Pinakas me ola ta tokens se antistoixia me tous orismous sto heading.h */
char *tname[16] = {"AKERAIOI","SXOLIA","LEKTIKA","ANAGNWRISTIKO","IMAGINARY","KINITIS","AKERAIOI_ERROR","SXOLIA_ERROR","LEKTIKA_ERROR","ANAGNWRISTIKA_ERROR"
,"IMAGINARY_ERROR","IMAGINARY_ERRO2","IMAGINARY_ERROR3","KINITIS_ERROR","KINITIS_ERROR2","KINITIS_ERROR3"};

int main(int argc, char **argv){
    int token;

        /* Ginetai o elegxos twn orismatwn ths grammhs entolwn. Ean ta
           orismata einai 3, to programma diabazei apo to arxeio tou 2ou
           orismatos kai grafei sto arxeio tou 3ou. Ean ta orismata einai
           2 diabazei apo to arxeio tou 2ou kai grafei sthn othonh.
           Ypenthymizetai oti to 1o orisma (argv[0]) sth C einai to onoma
           tou idiou tou ektelesimou arxeiou. */

    if(argc == 3){
        if(!(yyin = fopen(argv[1], "r"))) {
            fprintf(stderr, "Cannot read file: %s\n", argv[1]);
            return 1;
        }
        if(!(yyout = fopen(argv[2], "w"))) {
            fprintf(stderr, "Cannot create file: %s\n", argv[2]);
            return 1;
        }
    }
    else if(argc == 2){
        if(!(yyin = fopen(argv[1], "r"))) {
            fprintf(stderr, "Cannot read file: %s\n", argv[1]);
            return 1;
        }
    }

    /* H synarthsh yylex diabazei xarakthres apo thn eisodo kai prospathei
           na angnwrisei tokens. Ta tokens pou anagnwrizei einai auta pou exoun
           oristei sto paron arxeio, anamesa sta %% kai %%. An o kwdikas pou
           antistoixei se kapoio pattern periexei thn entolh 'return TIMH', h
       yylex() epistrefei thn timh auth h opoia kai apothhkeyetai sth
       metablhth token. */

    while( (token=yylex()) >= 0){
            /* Gia kathe token pou anagnwristhke, ektypwnetai h grammh pou auto
           brethhke kathws kai to onoma tou mazi me thn timh tou. */
        fprintf(yyout, "\tLine=%d, token=%s, value=\"%s\"\n", line, tname[token-1], yytext);
    }
    return 0;
}

/*I synartisi yyerror typwnei sto arxeio output.txt keimeno me to eidos tou lathous */

int yyerror(const char *s){
 fprintf(yyout,"\t%s --> ",s);
 return 0;
}


