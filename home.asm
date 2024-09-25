section .data
	;i would like to apologise what you will be seeing
	debug_text: db "Debug",0xA,0
	debug_text_len: equ $-debug_text
	
	opened_file_text: db "Contents:",0xA,0
	opened_file_text_len: equ $-opened_file_text

	part1: db "╭-------╮",0xA,0
	part1_len: equ $-part1

	; variations

	part2: db "|",0
	part2_len: equ $-part2

	part22: db "|███████|",0xA,0
	part22_len: equ $-part22

	part23: db "███|",0xA,0
	part23_len: equ $-part23

	part24: db "██|",0xA,0
	part24_len: equ $-part24

	part3: db "╰-------╯",0xA,0
	part3_len: equ $-part3

	button_img: db "   *",0
	button_img_len: equ $-button_img
	
	button_img2:db "   >",0
	button_img2_len: equ $-button_img2

	button_img3:db "   <",0
		button_img3_len: equ $-button_img3

	button_img4:db "  <",0
	button_img4_len: equ $-button_img4

	app_id1: db "  [1]",0
	app_id1_len: equ $-app_id1

	input_msg: db "Media_Selector> ",0
	input_msg_len: equ $-input_msg

	;small
	small_button: db "╭-----╮",0xA,0
	s_len1: equ $-small_button

	small_button_middle: db "|█████|",0xA,0
	s_len2: equ $-small_button

	small_button_start: db  "|",0
	s_len3: equ $-small_button_start

	small_button_end: db "██|",0xA,0
	s_len4: equ $-small_button_end

	small_button_bottom: db "╰-----╯",0xA,0
	s_len5: equ $-small_button
	
	file_too_big_text: db "...And more",0xA,0
	file_too_big_text_len: equ $-file_too_big_text
	
	file_no_content_text: db "It's quiet around here",0xA,0
	file_no_content_text_len: equ $-file_no_content_text

	;sorry
	file1: db "file1.txt",0
	file2: db "file2.txt",0
	file3: db "file3.txt",0
	file4: db "file4.txt",0
	file5: db "file5.txt",0
	files_folder: db "files",0


section .bss
	buffer: resb 112
	to_be_opened_file: resb 100
	app_num: resb 1
	fd: resb 5
	input_buffer: resb 1

section .text

global _start

_start:
	
	lea rsi, [button_img2]
	lea rdi, [fd]

	mov rcx, 5
	rep movsb

	call	create_button

	lea rsi, [button_img3]
	lea rdi, [fd]

	mov rcx, 5
	rep movsb

	call	create_button
	lea rsi, [button_img]
	lea rdi, [fd]

	mov rcx, 5
	rep movsb
	call    create_button
	call	create_sbutton
	call	media_selector

	; exit the program
	call	_exit

_exit:
	mov	rax,60
	mov	rdi,1
	syscall
_tell_opened_file:
	mov	rax,1
	mov	rdi,1
	mov	rsi,part22
	mov	rdx,part22_len
	syscall
	mov	rax,1
	mov	rdi,1
	mov	rsi,opened_file_text
	mov	rdx,opened_file_text_len
	syscall
	mov	rax,1
	mov	rdi,1
	mov	rsi,part22
	mov	rdx,part22_len
	syscall
	ret
_debugging:
	mov	rax,1
	mov	rdi,1
	mov	rsi,debug_text
	mov	rdx,debug_text_len
	syscall
	ret

media_selector:
	mov     rax,1
	mov     rdi,1
	mov     rsi,input_msg
	mov     rdx,input_msg_len
	syscall
	mov     rax,0
	mov     rdi,0
	mov     rsi,input_buffer
	mov     rdx,1
	syscall
;;;;;;;;AAAAAAAAAAA;;;;;;;;;;;

	mov	al,[input_buffer]
	sub     al, "0"
	lea	rsi,[file1]
	lea	rdi,[to_be_opened_file]
	mov	rcx,10
	cld
	rep movsb
	cmp	al,1
	je	_fileselector
;2
	mov     al,[input_buffer]
	sub     al, "0"
	lea     rsi,[file2]
	lea     rdi,[to_be_opened_file]
	mov     rcx,10
	cld
	rep movsb

	cmp	al,2
	je      _fileselector
;3
	mov     al,[input_buffer]
	sub     al, "0"
	lea     rsi,[file3]
	lea     rdi,[to_be_opened_file]
	mov     rcx,10
	cld
	rep movsb

	cmp	al,3
	je      _fileselector
;4
	mov     al,[input_buffer]
	sub     al, "0"
	lea     rsi,[file4]
	lea     rdi,[to_be_opened_file]
	mov     rcx,10
	cld
	rep movsb

	cmp	al,4
	je      _fileselector
	;a
	mov     al,[input_buffer]
	sub     al, "0"
	lea     rsi,[file5]
	lea     rdi,[to_be_opened_file]
	mov     rcx,10
	cld
	rep movsb

	cmp     al,5
	je      _fileselector
	ret

_fileselector:
	mov	rax,2
	lea	rdi,[rel files_folder]
	xor	rsi,rsi
	xor	rdx,rdx
	syscall

	test	rax,rax
	js	_debugging
	mov	rdi,rax

	mov     rax,257
	lea	rsi,[rel to_be_opened_file]
	xor	rdx,rdx
	xor	r10,r10 ;flags
	syscall

	test	rax,rax
	js	_debugging
	mov     rdi,rax ; save file descriptor

	;read file
	mov     rax,0
	lea	rsi,[buffer]
	mov     rdx,112
	syscall

	call	_tell_opened_file

	;write file
	mov	rax,1
	mov	rdi,1
	lea	rsi,[buffer]
	syscall
	call	file_content_check
	mov	rax,3
	syscall

	ret

create_sbutton:
	mov	byte [app_num],1
	mov	rax,1
	mov	rdi,1
	mov	rsi,small_button
	mov	rdx,s_len1
	syscall
	mov	rax,1
	mov	rdi,1
	mov	rsi,small_button_start
	mov	rdx,s_len3
	syscall
	mov	rax,1
	mov	rdi,1
	mov	rsi,button_img4
	mov	rdx,button_img4_len
	syscall
	mov     rax,1
	mov     rdi,1
	mov     rsi,small_button_end
	mov     rdx,s_len4
	syscall
	mov     rax,1
	mov     rdi,1
	mov     rsi,small_button_start
	mov     rdx,s_len3
	syscall
	mov     rax,1
	mov     rdi,1
	mov     rsi,app_id1
	mov     rdx,app_id1_len
	syscall
	mov     rax,1
	mov     rdi,1
	mov     rsi,small_button_end
	mov     rdx,s_len4
	syscall
	mov     rax,1
	mov     rdi,1
	mov     rsi,small_button_bottom
	mov     rdx,s_len5
	syscall
	ret

create_button:
	
	mov	rax,1
	mov	rdi,1
	mov	rsi,part1
	mov	rdx,part1_len
	syscall


	mov	rax,1
	mov	rdi,1
	mov	rsi,part2
	mov	rdx,part2_len
	syscall

	; button customizing
	lea	rsi,[fd]
	mov	rax,1
	mov	rdi,1
	mov	rsi,rsi
	mov	rdx,button_img_len
	syscall

	mov	rax,1
	mov	rdi,1
	mov	rsi,part23
	mov	rdx,part23_len
	syscall

	mov	rax,1
	mov	rdi,1
	mov	rsi,part2
	mov	rdx,part2_len
	syscall

	mov	rax,1
	mov	rdi,1
	mov	rsi,app_id1
	mov	rdx,app_id1_len
	syscall

	mov	rax,1
	mov	rdi,1
	mov	rsi,part24
	mov	rdx,part24_len
	syscall

	mov	rax,1
	mov	rdi,1
	mov	rsi,part22
	mov	rdx,part22_len
	syscall

	mov	rax,1
	mov	rdi,1
	mov	rsi,part3
	mov	rdx,part3_len
	syscall
	ret

file_content_check:
	mov	al,[buffer]
	cmp	al, 0
	je	no_file_content
	cmp	al,112
	jge	file_big
	ret

no_file_content:
	mov	rax,1
	mov	rdi,1
	mov	rsi,file_no_content_text
	mov	rdx,file_no_content_text_len
	syscall
	ret
file_big:
	mov	rax,1
	mov	rdi,1
	mov	rsi,file_too_big_text
	mov	rdx,file_too_big_text_len
	syscall
	ret
