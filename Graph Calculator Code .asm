asect 0

	setsp 0xf0              #set the stack pointer to 0xf0 for data flow
	ldi r0, 0xf0			#load r0 with the adress 0xf0
		
 	ld r0, r1				#load the value passed from to device into r0, using r1
	push r1					#push the value into the stack (coef1 value)
	ld r0, r1
	push r1					#coef2 value
	ld r0, r1
	push r1					#constant value
	
		clr r1
		clr r2
		ldi r1, -32         #r1 starting at x value -32
		ldi r2, 32			#should processed until 32
		
		
		while
		
			cmp r2, r1      #looping -32 to 32
			
		stays ge
		
			clr r2			
			addsp 2			#move stack pointer by 2
			pop r2         	#r2 now holds coef1
	
			addsp -3		#move stack pointer by -3
			
			
			jsr multiply    #go to muliplication
			
			
			move r3, r0     #moving r3 to r0 where it is saved in each subroutine (save ans from 1st mult)
			pop r2        	#pop constant
			
			add r2, r0      #constant + (X x Coef1)
			
			
			
			if 				#this if statement is to check if the constant + (X x Coef1) is 0, which in this case shouldnt be negated
			
				tst r0
				
			is z
							#do nothing
			else
			
			neg r0		   	#move value to right, so negate
			
			fi
			
			

			pop r2          #pop coef2 into r2
			
			addsp -4        #ready it for division sub by moving the stack pointer					
			
			
			
			if			    #depending on the value on the RHS, certain type of division will be executed
			
				tst r0
				
			is pl
			
			jsr posdivision
			
			else
			
			jsr negdivision
			
			fi
			
			
			
			setsp 0xf0
			ldi r2, 0xf0
			st r2, r3        #passing the data to the device
			
		
				
			
			ldi r2, 32       #reset the r2 for the bigger comparison while loop
			inc r1		     #inc -32 to -31 to -30 and so on
			setsp 0xed       #reset location for the stack pointer
			
		wend	
			
	
		
		
	
	multiply:   #need r1 to be X or Y # need r2 coef
	
		save r1
		
		#r0 is the count = set to 1
		#r1 is the X or Y from device -32, -31...
		#r2 is the coef multip
		#r3 is product sum = set 0
		
		clr r0
		ldi r0, 1
		clr r3
		ldi r3, 0
		
		while
			cmp r0, r2
		stays le
			add r1, r3
			inc r0
		wend
		
		restore r1
		
	rts
	
	
	posdivision:
		
		save r0
		save r1
		
		#r3 count = set to 0
		#r2 divider (Coef2) (bottom)
		#r0 dividend(top)
		
		clr r3
		ldi r3, 0
				
		while
			cmp r0, r2
		stays ge			
			neg r2
			add r2, r0
			neg r2
			inc r3
			
			ldi r1, 0xc0
			st r1, r3
			
		wend
		
		restore r1
		restore r0
	
	rts
	
	
	negdivision:
	
		save r0
		save r1	
		
		#r3 count = set to 0
		#r2 divider (Coef2) (bottom)
		#r0 dividend   (top)
		
		clr r3
		ldi r3, 0
		
		neg r0
				
		while
			cmp r0, r2
		stays ge			
			neg r2
			add r2, r0
			neg r2
			inc r3
			
			ldi r1, 0xc0
			st r1, r3
			
		wend
		
		neg r3
		
		restore r1
		restore r0

	rts
	
	
	
end






