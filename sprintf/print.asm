section .text
 
global _print
 
_print:
    push ebx
    push ebp
    push edi
    push esi
 
 
    mov eax, [esp+28]
    mov esi, esp
 
    mov ebx, 32
 
    ;Читаю знак и сохраняю его в cl
   
    xor ecx, ecx
    xor edx, edx    
 
    mov dl, [eax]
    cmp dl, '-'
    jne loop1
    mov cl, 1
    inc eax
    ;Записываю двоичную версию числа на стек
 
    loop1:
        xor edx, edx
        ;Читаем первый символ worda
        mov ch, [eax + ebx - 2]
        call symbolFromCH
        ;Читаем второй символ worda
        mov ch, [eax + ebx - 1]
        call symbolFromCH
        sub esp, 1
        mov [esp], dh
        sub ebx, 2
        jnz loop1
 
    cmp cl, 1
    jne n7
    call dop2
    n7:
 
    xor eax, eax
    mov al, BYTE [esp]
    shr al, 7
    cmp al, 1
    jne n8
    call dop2
    n8:
    mov edi, esp
    push eax     ;Сохраняем будущий знак на стек 1(-), 0(+)
 
    ;Перевожу в десятичную и записываю в обратном порядке
    mov ebp, esp
    add ebp, 20
 
 
    loop4:
        mov edx, ebp
        sub edx, 16
        call div10
        mov eax, edx
        mov edx, ebp
        sub edx, 16
        call is0
        push eax
        cmp edx, 0
        jne loop4
 
 
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
 
 
    mov ebx, [esi+24]
    loop6:
        mov cl, [ebx]
        cmp cl, 0
        je endloop6
        inc ebx
        cmp cl, '%'
        je loop6
        cmp cl, 'i'
        je loop6
        cmp cl, '-'
        jne n9
        mov dh, 1
        jmp loop6
        n9:
        cmp cl, '0'
        jne n10
        cmp ch, 1
        je n11
        cmp eax, 0
        jne n11
        cmp dh, 1
        je loop6
        mov dh, 2
        mov ch, 1
        jmp loop6
        n10:
        cmp cl, '+'
        jne n11
        mov dl, 1
        jmp loop6
        n11:
        push ecx
        push edx
        mov ecx, 10
        mul ecx
        pop edx
        pop ecx
        push ecx
        mov ch, 0
        sub ecx, '0'
        add eax, ecx
        pop ecx
        jmp loop6
    endloop6:
 
    sub edi, 4
 
    mov ebx, [esi+20]
    mov esi, 0
    mov ecx, edi
    sub ecx, esp
    shr ecx, 2
    push ebx
    mov ebx, [edi]
    cmp dl, 1
    jne n13
    inc ecx
    mov esi, 1
    mov dl, '-'
    cmp ebx, 0
    jne n18
    mov dl, '+'
    n18:
    jmp n19
 
    n13:
    cmp ebx, 1
    jne n19
    inc ecx
    mov esi, 1
    mov dl, '-'
 
    n19:
    pop ebx
    cmp eax, ecx
    ja n14
    mov eax, ecx
    n14:
    mov ecx, eax
    push edx
    mov dl, ' '
    call myFill
    mov dl, 0
    mov [ebx], dl
    pop edx
    sub ebx, eax
 
    mov ecx, edi
    sub ecx, esp
    shr ecx, 2
    add ecx, esi
 
    cmp dh, 0
    jne n15
        push eax
        sub eax, ecx
        add ebx, eax
        pop eax
        call printSign
        call printNum
    n15:
    cmp dh, 1
    jne n17
        call printSign
        call printNum
    n17:
    cmp dh, 2
    jne n16
        call printSign
        mov ecx, edi
        sub ecx, esp
        shr ecx, 2
        add ecx, esi
        push eax
        sub eax, ecx
        push edx
        mov dl, '0'
        mov ecx, eax
        call myFill
        pop edx
        pop eax
        call printNum
    n16:
    ;Чистим стек
    mov esp, ebp
 
 
    pop esi
    pop edi
    pop ebp
    pop ebx
    ret    
 
 
;Делит число на стэке (16 байта) на 10, остаток сохнаняет в edx.(портит регистр edx)
div10:
    push ecx
    push ebx
    push eax
    mov ecx, edx
    xor edx, edx
    mov ebx, 0
    xor eax, eax
    loop2:
        mov eax, DWORD [ecx+ebx*4]
        bswap eax
        push ecx
        mov ecx, 10
        div ecx
        pop ecx
        bswap eax
        mov [ecx+ebx*4], eax
        inc ebx
        cmp ebx, 4
        jne loop2
    pop eax
    pop ebx
    pop ecx
    ret
 
;Проверяет число на стэке (16 байта) на равность 0, записывает в edx 1, если выполнено(портит регистр edx)
is0:
    push eax
    push ebx
    push ecx
 
    mov ecx, 4
    mov ebx, 0
    loop3:
        dec ecx
        mov eax, DWORD [edx+ecx*4]
        cmp eax, 0
        je n5
        mov ebx, 1
        jmp endloop3
        n5:
        cmp ecx, 0
        jne loop3
    endloop3:
    mov edx, ebx
    pop ecx
    pop ebx
    pop eax
    ret
 
;Приментяет к числу на стеке (16 байта от esp) дополнение до двух.
dop2:
    push eax
    push ebx
    push ecx
    push edx
 
    mov ebx, 4
    mov ecx, 1
    loop5:
        dec ebx
        mov eax, [esp + ebx*4 + 20]
        bswap eax
        not eax
        add eax, ecx
        bswap eax
        mov [esp + ebx*4+20], eax
        jnc n6
        dec ecx
        n6:
        dec ecx      ;ecx = 0 or 1
        cmp ebx, 0
        jne loop5
 
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
 
;Вычисляет число, по 16-ричному символу в ch и добавляет его в dh со сдвигом
symbolFromCH:
    cmp ch, '9'
    ja n1
    sub ch, '0'
    jmp n2
    n1:
    sub ch, 'A'
    add ch, 10
    n2:
    shl dh, 4
    add dh, ch
    ret
 
;Заполняет ecx байт начиная с ebx символами в dl
myFill:
    push eax
    mov eax, 0
    loop9:
        cmp eax, ecx
        jae endloop9
        mov [ebx], dl
        inc ebx
        inc eax
        jmp loop9
    endloop9:
    pop eax
    ret
 
;Выводит последние байты DWORD от esp (до вызова функции) до edi в [ebx]
printNum:
    push eax
    push ecx
    mov ecx, esp
    add ecx, 12
    loop8:
        mov eax, [ecx]
        add al, '0'
        mov [ebx], al
        inc ebx
        add ecx, 4
        cmp ecx, edi
        jne loop8
    pop ecx
    pop eax
    ret
 
;Выводи знак из dl в ebx и делает ebx++, если esi = 1
printSign:
    cmp esi, 1
    jne n20
    mov [ebx], dl
    inc bx
    n20:
    ret