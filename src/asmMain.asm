
[default rel]

%define NULL 0

%define GL_COLOR 0x1800
%define GL_DEPTH_STENCIL 0x84F9

[section .text]

    [extern glfwInit]
    [extern glfwTerminate]

    [extern glfwCreateWindow]
    [extern glfwMakeContextCurrent]
    [extern glfwWindowShouldClose]
    [extern glfwPollEvents]
    [extern glfwSwapBuffers]
    [extern glfwDestroyWindow]

    [extern glfwGetProcAddress]

    [extern gladLoadGLLoader]

    [extern glad_glClearBufferfv]
    [extern glad_glClearBufferfi]

    [global asmMain]
    asmMain:

        push        rbp
        mov         rbp, rsp
        sub         rsp, 48

        ; ----------------------------------------------------------------------------------------------------------------------------
        ; Initialize GLFW
        ; ----------------------------------------------------------------------------------------------------------------------------
        call        glfwInit

        ; ----------------------------------------------------------------------------------------------------------------------------
        ; Create window, glfwCreateWindow(1600, 900, window_name, NULL, NULL);
        ; ----------------------------------------------------------------------------------------------------------------------------
        mov         ecx, 1600                   ; Width
        mov         edx, 900                    ; Height
        lea         r8, [window_name]           ; Title
        xor         r9, r9                      ; Monitor
        mov         qword [rsp + 32], NULL      ; Shared window
        call        glfwCreateWindow
        mov         [window], rax

        ; ----------------------------------------------------------------------------------------------------------------------------
        ; Make window's context current
        ; ----------------------------------------------------------------------------------------------------------------------------
        mov         rcx, rax
        call        glfwMakeContextCurrent

        ; ----------------------------------------------------------------------------------------------------------------------------
        ; Load OpenGL
        ; ----------------------------------------------------------------------------------------------------------------------------
        lea         rcx, [glfwGetProcAddress]
        call        gladLoadGLLoader

    .main_loop:

        ; ----------------------------------------------------------------------------------------------------------------------------
        ; Clear
        ; ----------------------------------------------------------------------------------------------------------------------------
        mov         ecx, GL_COLOR
        xor         edx, edx
        lea         r8, [clear_color]
        call        [glad_glClearBufferfv]

        mov         ecx, GL_DEPTH_STENCIL
        xor         edx, edx
        movd        xmm2, [depth_color]
        mov         r9d, 1
        call        [glad_glClearBufferfi]

        ; ----------------------------------------------------------------------------------------------------------------------------
        ; Poll events and swap buffers
        ; ----------------------------------------------------------------------------------------------------------------------------
        call        glfwPollEvents
        
        mov         rcx, [window]
        call        glfwSwapBuffers

        ; ----------------------------------------------------------------------------------------------------------------------------
        ; Check if the window is still open
        ; ----------------------------------------------------------------------------------------------------------------------------
        mov         rcx, [window]
        call        glfwWindowShouldClose
        test        al, al
        jz          .main_loop

    .quit:

        ; ----------------------------------------------------------------------------------------------------------------------------
        ; Cleanup GLFW resources
        ; ----------------------------------------------------------------------------------------------------------------------------
        mov         rcx, [window]
        call        glfwDestroyWindow

        call        glfwTerminate

        xor         eax, eax
        leave
        ret

[section .data]

        ; const float[4]
        clear_color:        dd __float32__(0.1), __float32__(0.1), __float32__(0.15), __float32__(1.0),

        ; const float
        depth_color:        dd __float32__(1.0),

        ; const char*
        window_name:        db "My window"

        ; GLFWwindow*
        window:             dq 0
