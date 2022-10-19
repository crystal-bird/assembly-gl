
; From glfw3.h

%ifndef __glfw3_inc__
%define __glfw3_inc__

[extern glfwInit]
[extern glfwTerminate]

[extern glfwWindowHint]

[extern glfwCreateWindow]
[extern glfwMakeContextCurrent]
[extern glfwWindowShouldClose]
[extern glfwPollEvents]
[extern glfwSwapBuffers]
[extern glfwDestroyWindow]

[extern glfwGetProcAddress]

%define GLFW_CONTEXT_VERSION_MAJOR  0x00022002
%define GLFW_CONTEXT_VERSION_MINOR  0x00022003

%define GLFW_OPENGL_PROFILE         0x00022008

%define GLFW_OPENGL_ANY_PROFILE              0
%define GLFW_OPENGL_CORE_PROFILE    0x00032001
%define GLFW_OPENGL_COMPAT_PROFILE  0x00032002

%endif
