addi $s0, $0, 5 # 0101
sw $s0, 1($s0) # saving 5 at memory adr 6
#lw $s2, 0($s1)
# this is wrong below
#add $s0, $s2, $s1 # 1010
#or $s1, $s2, $s0 # 1111
#and $s0, $s1, $s2 # 1010
#sub $s0, $s2, $s1 # 0101
#slt $s0 ,$s1, $s2 # 1111 true

