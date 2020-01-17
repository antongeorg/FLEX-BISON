/* 
OMADA:Ε7 - PEMPTI 10-12 
MELOI:GEWRGAKOPOULOS ANTONIOS - KASNIS GEWRGIOS
	  CS131107                - CS131016
<<TELIKI ASKISI BYSON>>	  
*/

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int line=1;
int errflag=0;
char lineText[50];
extern char *yytext;
#define YYSTYPE char *
%}


%token PLUS MINUS TIMES DIVIDE KOMA ISON ANO LEFT RIGHT LFT RGHT POWER 

%token ANAGNWRISTIKO DEL LEKTIKA LEN CMP PRINT TOKEN DEF ANAGN RETURN
%token END

%start lin
%%

lin: |lin programm
     ;

programm: atom END
         |simple_stmt END
	 |arithmetic_stmt END
	 |assignment_stmt END
         |merge_ltp END
	 |def_stmt END
	 |END
	 |error { errflag=1; }
	 ;


		 
atom: ANAGNWRISTIKO 
	| LEKTIKA 
	| enclosure		    
	;
	
enclosure: list
	 |tuple
	 ;
		
	

simple_stmt: del_stm 	
			| len_stm 	
			| cmp_stm	
			| print_stm
			;
			
del_stm:DEL LEFT ANAGNWRISTIKO RIGHT
		;

len_stm: LEN RIGHT list LEFT 
		| LEN RIGHT tuple LEFT 
		;
		
cmp_stm: CMP RIGHT list KOMA list LEFT 
       |CMP RIGHT list KOMA ANAGNWRISTIKO LEFT 
	   |CMP RIGHT ANAGNWRISTIKO KOMA list LEFT 
	   |CMP RIGHT ANAGNWRISTIKO KOMA ANAGNWRISTIKO LEFT 
	   |CMP RIGHT ANAGNWRISTIKO KOMA tuple LEFT 
	   |CMP RIGHT tuple KOMA ANAGNWRISTIKO LEFT 
	   |CMP RIGHT tuple KOMA tuple LEFT 
	   ;
	   
print_stm: PRINT CMP 
		| PRINT CMP RIGHT list list LEFT  
		;
merge_ltp: list PLUS list
		| list PLUS tuple
		| tuple PLUS list
		|tuple PLUS tuple
		;
list: LEFT starred_expression RIGHT
	;
	
tuple: LFT starred_expression RGHT
	;

starred_expression: starred_item 
		| starred_expression KOMA starred_item 
		;

starred_item:ANAGNWRISTIKO
	    |LEKTIKA
	     ;

def_stmt:DEF after_func END function_string END func_suit END RETURN;
after_func:RIGHT parameters LEFT;
parameters:ANAGNWRISTIKO|parameters KOMA ANAGNWRISTIKO;
function_string:LEKTIKA;
func_suit:allo|print_stm
allo:target_list ISON arithmetic_stmt;
		
arithmetic_stmt: m_expr 
		| a_expr
		;

				
m_expr: u_expr 
       | m_expr TIMES u_expr 
       | m_expr DIVIDE u_expr 
      ;

a_expr: m_expr 
       | a_expr PLUS m_expr 
       | a_expr MINUS m_expr 
      ;	  
	  
u_expr: ANAGNWRISTIKO
       |LEKTIKA 
       | MINUS u_expr 
       | PLUS u_expr 
      ;
	  
assignment_stmt: target_list ISON target
				;
target_list: ANAGNWRISTIKO
	     |target_list KOMA ANAGNWRISTIKO 
			;
target:ANAGNWRISTIKO
	;


%%


int yyerror(void)
{}


/* O deikths yyin einai autos pou "deixnei" sto arxeio eisodou. Ean den ginei xrhsh
   tou yyin, tote h eisodos ginetai apokleistika apo to standard input (plhktrologio) */

FILE *yyin;


/* H synarthsh main pou apotelei kai to shmeio ekkinhshs tou programmatos.
   Ginetai elegxos twn orismatwn ths grammhs entolwn kai klhsh ths yyparse
   pou pragmatopoiei thn syntaktikh analysh. Sto telos ginetai elegxos gia
   thn epityxh h mh ekbash ths analyshs. */

int main()
{

	if (errflag==0 && yyparse()==0)
		//fprintf("\nINPUT FILE: PARSING SUCCEEDED. :%d\n", parse);
		fprintf(stderr,"Succesful.\n");	
	else
		//fprintf("\nINPUT FILE: PARSING FAILED. :%d\n", parse);
		fprintf(stderr,"Fail.\n");
	return 0;
}
