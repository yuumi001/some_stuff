.386
.model flat
.data
string db "Hello world!", 0ah, 0
fwrite db "WriteConsoleA",0
fgstdh db "GetStdHandle", 0
fexit db "ExitProcess", 0
.data?
bkernel dd 1 dup(?) 
vaxedtbl dd 1 dup (?)
rvaxeddir dd 1 dup (?)
fawrite dd 1 dup (?)
fagstdh dd 1 dup (?)
faexit dd 1 dup (?)
written dd 1 dup (?)
handle dd 1 dup (?)
.code
_main proc
    call GetBaseAddr
    call GetExportedTable

    push offset fawrite
    push offset fwrite
    call FindAddr

    push offset fagstdh
    push offset fgstdh
    call FindAddr

    push offset faexit
    push offset fexit
    call FindAddr

    mov eax,fagstdh
    push -11
    call eax
    mov handle, eax

    mov eax, fawrite
    push 0
    push offset written
    push 13
    push offset string
    push handle
    call eax

    mov eax, faexit
    push 0
    call eax
    
_main endp

GetBaseAddr proc
    push ebp
    mov ebp, esp
    push eax
    xor eax, eax
    assume fs:nothing
    mov eax, fs:[eax + 30h]     ; EAX = PEB
    mov eax, [eax + 0ch]        ; EAX = PEB->Ldr
    mov esi, [eax + 14h]        ; ESI = PEB->Ldr.InMemoryOrderModuleList
    lodsd                       ; EAX = 2nd Module (ntdll.dll)
    xchg eax, esi               ; Next module
    lodsd                       ; EAX = 3rd Module (Kernel32.dll)
    mov eax, [eax + 10h]        ; Base Address
    assume fs:error
    mov bkernel, eax
    leave
    ret
GetBaseAddr endp

GetExportedTable proc
    push ebp
    mov ebp, esp
    mov ebx, [eax + 3ch]        ; RVA of PE signature (e_lfanew) | EAX point to e_magic
    add ebx, eax                ; VA of PE signature
    mov ebx, [ebx + 78h]        ; RVA of the exported directory
    add ebx, eax                ; VA of the exported directory
    mov rvaxeddir, ebx
    mov esi, [ebx + 20h]        ; RVA of the exported table
    add esi, eax                ; VA of the exported table
    mov vaxedtbl, esi
    leave
    ret
GetExportedTable endp

FindAddr proc
    push ebp
    mov ebp, esp
    push ebx
    xor ecx, ecx
    xor ebx, ebx
    push bkernel
    mov esi, vaxedtbl
    l1:
    pop eax
    inc ecx
    lodsd                       ; Load RVA to EAX, ESI = *nextRVA
    add eax, bkernel                ; VA of function name
    push eax
    mov edx, [ebp + 8]
    cmploop:
    mov bl, [eax]
    mov bh, [edx]
    inc eax
    inc edx
    cmp bh, 0
    je endcmp
    cmp bh, bl
    je cmploop
    jmp l1
    endcmp:
    pop eax
    mov ebx, rvaxeddir
    mov esi, [ebx + 24h]
    add esi, bkernel
    mov cx, [esi + ecx *2]
    dec ecx
    mov esi, [ebx + 1ch]
    add esi, bkernel
    mov edi, [esi + ecx *4]
    add edi, bkernel
    mov ebx, [ebp+12]
    mov [ebx], edi
    pop ebx
    leave
    ret
FindAddr endp
end _main