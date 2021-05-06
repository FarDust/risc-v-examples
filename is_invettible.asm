# https://web.eecs.utk.edu/~smarz1/courses/ece356/notes/assembly/
.globl start
.data
    # --- MATRIZ ---
    M: .byte 1, 0, 0, 0, 1, 0, 0, 0, 1  # representacion de matriz M
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

    sum_row3: # Funcion sum_row3 recibe 3 argumentos
        # a0: puntero a la matriz
        # a1: tamaño de la matriz
        # a2: indice de la fila (i) de la matrix 
        sum_row3_init:
            addi sp, sp , -24 # Pedimos memoria del stack
            sw ra, 0(sp) # Guardar direccion de retorno
            sw t3, 8(sp) # Guardar registro temporal del caller
            sw s0, 16(sp)
        sum_row3_call:
            mv t0, zero # Establecer contador (j) a zero
            mv t1, zero # Establecer suma a zero
            sum_row3_loop:
                bge t0, a1, sum_row3_return
                
                add t3, a2, a0 # añadimos a el tamaño de la matriz (a2) a la direccion de memoria (a0)
                add t3, t0, t3 # añadimos la nueva dirección (t3) a el contador de columnas (j) 
                    
                lb t2, 0(t3)

                addi sp, sp , -24 # ubicamos el stack pointer para poder almacenar valores
                sw a0, 0(sp) # Guardamos a0 en el stack pues abs1 lo utilizara
                sb t0, 8(sp) # Guardamos el contador en el stack
                sb t1, 16(sp) # Guardamos el resultado de la suma en el stack
                mv a0, t2
                call abs1
                mv t2, a0 # Guardamos el retorno en t2
                lw a0, 0(sp) # Restauramos el puntero original de la matriz
                lb t0, 8(sp) # Restauramos el contador
                lb t1, 16(sp) # Restauramos el resultado de la suma
                addi sp, sp , 24 # Restablecemos el stack pointer

                beq t0, a2, sum_row3_negate # Si el contador es igual a N es decir a_{i,i}
                j sum_row3_adition
                sum_row3_negate:
                    neg t2, t2 # Negamos en complemento 2 a t2
                sum_row3_adition:
                    add t1, t1, t2 # Sumamos el valor abs(t2) de la fila y lo guardamos en t1
                sum_row3_end_loop:
                    addi t0, t0, 1 # Aumentar el contador en 1
                    j sum_row3_loop  # jump to sum_row3_loop
        sum_row3_return:
            neg t1, t1
            mv a0, t3 # retornamos el puntero a la ultima posicion de la matriz
            mv a1, t1 # retornamos la suma 
            lw ra, 0(sp) # Restablecer direccion de retorno
            lw t3, 8(sp) # Restablecer registro temporal del caller
            lw s0, 16(sp)
            addi sp, sp, 24 # Restablecemos el stack pointer
            ret # Retornamos a (ra)

    start:
        init:
            lui a0, %hi(M) # Guardamos la direccion de memoria de M en a0
            lb a1, N # Guardamos N en a1
            mv t0, zero # Contador de iteraciones por (i)
            mv t1, zero # Suma de la fila de la matriz
            mv t2, zero # Placeholder de retorno
        call:
            loop:
                mv a2, zero
                bge t0, a1, end_loop # if t0 >= a1 then end_loop

                addi sp, sp , -16 # ubicamos el stack pointer para poder almacenar valores
                sb a1, 0(sp) # Guardamos el valor N en el stack
                sb t0, 8(sp) # Guardamos el contador en el stack
                call sum_row3 # llamamos a sum_row3(a0, a1, a2)
                mv t1, a1 # guardamos el valor de nuestra suma en t1 😊
                lb a1, 0(sp) # Restauramos el valor N en a1
                lb t0, 8(sp) # Restauramos el contador en t0
                addi sp, sp , 16 # Restauramos el sp a su posicion original

                bgt t1, zero, true # if t1 > zero then 1f
                mv t2, zero
                j return
                true:
                    addi t2, zero, 1 # t2 = t1 + 1
                end_loop:
                    addi t0, t0, 1
                    j loop
        return:
            mv a0, t2







    

    
