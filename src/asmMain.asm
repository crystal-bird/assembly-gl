
[default rel]

%define NULL 0

%include "glfw.inc"
%include "glad.inc"

[section .text]

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
        ; Window hints
        ; ----------------------------------------------------------------------------------------------------------------------------
        mov         ecx, GLFW_CONTEXT_VERSION_MAJOR
        mov         edx, 4
        call        glfwWindowHint

        mov         ecx, GLFW_CONTEXT_VERSION_MINOR
        mov         edx, 6
        call        glfwWindowHint

        mov         ecx, GLFW_OPENGL_PROFILE
        mov         edx, GLFW_OPENGL_CORE_PROFILE
        call        glfwWindowHint

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
