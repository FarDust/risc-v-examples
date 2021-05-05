# https://web.eecs.utk.edu/~smarz1/courses/ece356/notes/assembly/
.globl start
.data
    # --- MATRIZ ---
    M: .byte 1, 0, 0, 0, -1, 0, 0, 0, 1  # representacion de matriz M
    N: .byte 3 # tamano de la matriz
    # --- END MATRIZ ---
    # de aca para abajo van sus variables en memoria
.text

    j start  # jump to start
    
    abs1: # Funcion abs recibe 1 argumento
        abs1_init:
            addi sp, sp , -16 # Pedimos memoria del stack
            sw ra, 0(sp) # Guardar direccion de retorno
            sw s0, 8(sp) 
        abs1_call:
            bge a0, zero, abs1_return # if (a0 >= 0)
            mv t0, a0 # Mover argumento de llamada
            neg a0, t0 # Negamos en complemento 2 a a0
        abs1_return:
            lw ra, 0(sp) # Restablecer direccion de retorno
            lw s0, 8(sp)
            addi sp, sp, 16 # Restablecemos el stack pointer
            ret # Retornamos a (ra)

    sum_diagonal2: # Funcion sum_diagonal recibe 2 argumentos
        # a0: puntero a la matriz
        # a1: tamaño de la matriz
        sum_diagonal3_init:
            addi sp, sp , -16 # Pedimos memoria del stack
            sw ra, 0(sp) # Guardar direccion de retorno
            sw s0, 8(sp)
        sum_diagonal3_call:
            mv t0, zero # Establecer contador a zero
            sum_diagonal3_loop:
                bge t0, a1, sum_diagonal3_return
                
                sb t1, a0(t0)

                addi sp, sp , -16
                sb a0, 16(sp) # Guardamos a0 en el stack pues abs1 lo utilizara
                sb t0, 24(sp) # Guardamos el contador en el stack
                mv a0, t0
                call abs1
                mv t0, a0
                lb a0, 16(sp)
                lb t0, 24(sp)
                addi sp, sp , 16


                addi t0, t0, 1 # Aumentar el contador en 1
        sum_diagonal3_return:
            lw ra, 0(sp) # Restablecer direccion de retorno
            lw s0, 8(sp)
            addi sp, sp, 16 # Restablecemos el stack pointer
            ret # Retornamos a (ra)

    start:
        lb a0, M
        lb a1, N
        call sum_diagonal3
        



    

    
