[org 0x7c00]

jmp short start
nop

                            db 'AC17OS  '
                            dw 512       ; =512 bytes per sector
                            db 0x01         ; 1 sector per cluster
                            dw 0x01         ; reserved sector
                            db 0x02         ; no of file allocation tables
                            dw 0xe0         ; root dir entry
                            dw 2880         ; total sectors
                            db 0xf0         ; media descriptor = 3.5" or 1.44MB floppy
                            dw 9            ; sectors per fat
sectors_per_track:          dw 18           ; sectors per track
head_count:                 dw 2            ; head count
                            dd 0            ; hidden sector
                            dd 0            ; large sector

; extended boot record

                            db 0            ; drive number
                            db 0
                            db 0x29         ; signature
                            db 0x12, 0x34, 0x56, 0x78 ; volume id
                            db 'AvinOS     '; volume label
                            db 'FAT16   '   ; system id label


start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov cx, 2000
clear:
    mov ah, 0x0e
    mov al, blank
    mov bh, 0
    int 0x10
    dec cx
    jnz clear

greet:
    mov bp, msg
    mov cx, msg_len
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0e
    mov dl, 0
    mov dh, 0
    int 0x10

booting:
    mov bp, booting_from_disk
    mov cx, booting_from_disk_len
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0e
    mov dl, 0
    mov dh, 5
    int 0x10


;
; LBA to CHS
;   - ax : LBA 
; returns
;   - cx [0-5]  : sector 
;   - cx [6-16] : cylinder
;   - dh        : head

lba_to_chs:
; to do




    jmp $

    blank equ ' '

    booting_from_disk db 'Booting from disk...', 0
    booting_from_disk_len equ $ - booting_from_disk
    
    msg db 32,32,95,95,32,95,95,95,32,95,40,95,41,95,32,95,32,47,32,95,32,92,47,32,95,95,124,13,10,32,47,32,95,96,32,92,32,86,32,47,32,124,32,39,32,92,32,40,95,41,32,92,95,95,32,92,13,10,32,92,95,95,44,95,124,92,95,47,124,95,124,95,124,124,95,92,95,95,95,47,124,95,95,95,47
    msg_len equ $ - msg
    
    times 440-($-$$) db 0


;
; hard disk parition table
;
    unique_disk_id:     dd 0xacacacac       ; signature
    reserved:           dw 0x0000           ; set to 0x0000
    first_paritition:   dq 0x11223344
                        dq 0x0              ; 16 bytes 
    second_partition:   dq 0x55667788
                        dq 0x0
    third_parition:     dq 0x99AABBCC
                        dq 0x0
    fourth_parition:    dq 0xDDEEFF00
                        dq 0x0
    dw 0xaa55